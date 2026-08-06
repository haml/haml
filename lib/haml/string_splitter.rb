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
          node.unescaped.empty? ? [] : [[:static, node.unescaped]]
        when Prism::InterpolatedStringNode
          compile_parts(node.parts, code)
        else
          raise(Haml::InternalError, "Expected a string literal but got: #{code}")
        end
      end

      private

      def compile_parts(parts, code)
        [].tap do |exps|
          parts.each do |part|
            case part
            when Prism::StringNode
              content = part.unescaped
              exps << [:static, content] unless content.empty?
            when Prism::EmbeddedStatementsNode
              embedded = embedded_source(part, code)
              exps << [:dynamic, embedded] unless embedded.empty?
            when Prism::EmbeddedVariableNode
              exps << [:dynamic, part.variable.slice]
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
