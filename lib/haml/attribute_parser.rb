# frozen_string_literal: true
require 'prism'

module Haml
  class AttributeParser
    # @deprecated Prism is a hard dependency, so this is always true. Haml itself no longer
    #   asks, and this will be removed in the future.
    # @return [TrueClass] - return true if AttributeParser.parse can be used.
    def self.available?
      true
    end

    def self.parse(text)
      self.new.parse(text)
    end

    # @return [Hash,nil] - keys and values are the attribute source as written, or nil if
    #   the text is not a Hash literal whose keys are all static, or if it holds a heredoc.
    def parse(text)
      exp = wrap_bracket(text)
      node = hash_node(exp)
      return if node.nil? || contains_heredoc?(exp, node)

      hash = {}
      node.elements.each do |element|
        return unless element.is_a?(Prism::AssocNode)

        key = static_key(element.key)
        return if key.nil?

        hash[in_source_encoding(key, exp)] = in_source_encoding(value_source(element.value), exp)
      end
      hash
    end

    private

    def wrap_bracket(text)
      text = text.strip
      return text if text[0] == '{'
      "{#{text}}"
    end

    def hash_node(exp)
      # partial_script, because an attribute may legitimately call `yield` and the like:
      # a template is compiled into a method body.
      result = Prism.parse(exp, partial_script: true)
      return if result.failure?

      statements = result.value.statements.body
      return if statements.size != 1

      node = statements.first
      node if node.is_a?(Prism::HashNode)
    end

    # A heredoc's body lies outside its node, so the value's slice would not be the value.
    # Its opener always spells `<<`, which spares the tree walk for nearly every hash.
    def contains_heredoc?(exp, node)
      exp.include?('<<') && !node.breadth_first_search { |n| n.respond_to?(:heredoc?) && n.heredoc? }.nil?
    end

    # The key as written between its delimiters, not unescaped: an escape has to reach the
    # attribute name as the source spelled it, like the `\0` of `{ "a\0b" => 1 }`.
    def static_key(key)
      case key
      when Prism::SymbolNode then key.value_loc&.slice
      when Prism::StringNode then key.content_loc&.slice
      end
    end

    def value_source(value)
      # Ruby 3.1 value omission (`{ foo: }`). An empty value tells AttributeCompiler to
      # fall back to the runtime, which is what resolves it.
      return '' if value.is_a?(Prism::ImplicitNode)

      value.slice
    end

    # Prism tags its slices with the encoding it parsed the source under (UTF-8 for a
    # BINARY source), while the rest of the compiled template stays in the source
    # encoding. Mixing the two raises Encoding::CompatibilityError once both sides hold
    # non-ASCII bytes, so bring everything back to the source encoding.
    def in_source_encoding(string, source)
      return string if string.encoding == source.encoding

      string.dup.force_encoding(source.encoding)
    end
  end
end
