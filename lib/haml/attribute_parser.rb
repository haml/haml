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
    #   the text is not a Hash literal whose keys are all static.
    def parse(text)
      exp = wrap_bracket(text)
      # A multi-line hash is left to the runtime, which keeps the [:newline] bookkeeping of
      # the compiled code correct. Compiling it statically is a separate optimization.
      return if exp.include?("\n")

      node = hash_node(exp)
      return if node.nil?

      hash = {}
      node.elements.each do |element|
        return unless element.is_a?(Prism::AssocNode)

        key = static_key(element.key)
        return if key.nil?

        hash[key] = value_source(element.value)
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
      result = Prism.parse(exp)
      return if result.failure?

      statements = result.value.statements.body
      return if statements.size != 1

      node = statements.first
      node if node.is_a?(Prism::HashNode)
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
  end
end
