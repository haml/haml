# frozen_string_literal: true
require 'prism'

module Haml
  class RubyExpression
    # A character literal (`?a`) is a StringNode for Prism, but it has no quotes
    # to split on, so it must not be reported as a string literal.
    CHAR_LITERAL_OPENING = '?'

    # A template is compiled into a method body, so a jump like `yield` is valid here even
    # though it would not be at the top level of a script.
    PARSE_OPTIONS = { partial_script: true }.freeze

    def self.syntax_error?(code)
      Prism.parse_failure?(code, **PARSE_OPTIONS)
    end

    def self.string_literal?(code)
      !string_literal_node(code).nil?
    end

    # @return [Prism::Node, nil] - the node of a string literal StringSplitter can split, if any.
    #   Its locations are byte offsets into `code` as given, so `code` must not be stripped here.
    def self.string_literal_node(code)
      result = Prism.parse(code, **PARSE_OPTIONS)
      return if result.failure?

      statements = result.value.statements.body
      return if statements.size > 1

      case (node = statements.first)
      when Prism::StringNode, Prism::InterpolatedStringNode
        # Adjacent concatenation (`"a" "b"`) is one node without an opening
        # delimiter of its own, and each of its parts keeps its own quotes.
        node if !node.opening.nil? && node.opening != CHAR_LITERAL_OPENING
      end
    end
  end
end
