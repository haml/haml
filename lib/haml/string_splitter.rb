# frozen_string_literal: true
require 'prism'
require 'haml/ruby_expression'

module Haml
  # Compile [:dynamic, "foo#{bar}"] to [:multi, [:static, 'foo'], [:dynamic, 'bar']]
  class StringSplitter < Temple::Filter
    class << self
      # `code` param must be a string literal, as RubyExpression.string_literal? defines it.
      def compile(code, node: RubyExpression.string_literal_node(code))
        case node
        when Prism::StringNode
          node.unescaped.empty? ? [] : [[:static, in_source_encoding(node.unescaped, code)]]
        when Prism::InterpolatedStringNode
          compile_parts(node.parts, code)
        else
          raise(Haml::InternalError, "Expected a string literal but got: #{code}")
        end
      end

      # Like compile, but nil instead of raising, for callers that built `code` themselves
      # and would rather emit it untouched than fail the whole compilation.
      def try_compile(code)
        node = RubyExpression.string_literal_node(code)
        compile(code, node: node) unless node.nil?
      end

      private

      def compile_parts(parts, code)
        [].tap do |exps|
          parts.each do |part|
            case part
            when Prism::StringNode
              content = part.unescaped
              exps << [:static, in_source_encoding(content, code)] unless content.empty?
            when Prism::EmbeddedStatementsNode
              embedded = embedded_source(part, code)
              exps << [:dynamic, embedded] unless embedded.empty?
            when Prism::EmbeddedVariableNode
              exps << [:dynamic, in_source_encoding(part.variable.slice, code)]
            else
              # Prism allows more part types than a string literal can currently hold. Dropping
              # one would silently lose content, so fail instead of rendering something wrong.
              raise(Haml::InternalError, "Unexpected #{part.class} in string literal: #{code}")
            end
          end
        end
      end

      # The source between `#{` and `}`, kept verbatim. Slicing `code` rather than
      # using the statements' own source preserves the whitespace around them.
      def embedded_source(part, code)
        from = part.opening_loc.end_offset
        code.byteslice(from, part.closing_loc.start_offset - from)
      end

      # Prism tags what it returns with the encoding it parsed `code` under (UTF-8 for
      # a BINARY source), while the fragments Haml slices out of the source itself keep
      # the source encoding. The compiled template mixes both kinds, so anything taken
      # from Prism has to come back to the source encoding, or joining the fragments
      # raises Encoding::CompatibilityError once both sides hold non-ASCII bytes.
      def in_source_encoding(string, code)
        return string if string.encoding == code.encoding

        string.dup.force_encoding(code.encoding)
      end
    end

    def on_dynamic(code)
      return [:dynamic, code] if code.include?("\n")

      node = RubyExpression.string_literal_node(code)
      return [:dynamic, code] if node.nil?

      temple = [:multi]
      StringSplitter.compile(code, node: node).each do |type, content|
        case type
        when :static
          temple << [:static, content]
        when :dynamic
          temple << on_dynamic(content)
        end
      end
      temple
    end
  end
end
