require 'ripper'

module Hamlit
  class SyntaxChecker < Ripper
    class ParseError < StandardError; end

    def self.syntax_error?(code)
      self.new(code).parse
      false
    rescue ParseError
      true
    end

    private

    def on_parse_error(*)
      raise ParseError
    end
  end
end
