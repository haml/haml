# frozen_string_literal: true
require 'prism'

module Haml
  class RubyExpression
    # A character literal (`?a`) is a StringNode for Prism, but it has no quotes
    # to split on, so it must not be reported as a string literal.
    CHAR_LITERAL_OPENING = '?'

    def self.syntax_error?(code)
      Prism.parse_failure?(code)
    end

    def self.string_literal?(code)
      result = Prism.parse(code)
      return false if result.failure?

      statements = result.value.statements.body
      return false if statements.size > 1

      case (node = statements.first)
      when Prism::StringNode, Prism::InterpolatedStringNode
        # Adjacent concatenation (`"a" "b"`) is one node without an opening
        # delimiter of its own, and each of its parts keeps its own quotes.
        !node.opening.nil? && node.opening != CHAR_LITERAL_OPENING
      else
        false
      end
    end
  end
end
