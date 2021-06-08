# frozen_string_literal: true
require 'ripper'
require 'hamlit/ruby_expression'

module Hamlit
  module StringSplitter
    # `code` param must be valid string literal
    def self.compile(code)
      unless Ripper.respond_to?(:lex) # truffleruby doesn't have Ripper.lex
        return [[:dynamic, code]]
      end

      begin
        Temple::Filters::StringSplitter.compile(code)
      rescue Temple::FilterError => e
        raise Hamlit::InternalError.new(e.message)
      end
    end
  end
end
