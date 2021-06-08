# frozen_string_literal: true
require 'ripper'
require 'haml/ruby_expression'

module Haml
  module StringSplitter
    # `code` param must be valid string literal
    def self.compile(code)
      unless Ripper.respond_to?(:lex) # truffleruby doesn't have Ripper.lex
        return [[:dynamic, code]]
      end

      begin
        Temple::Filters::StringSplitter.compile(code)
      rescue Temple::FilterError => e
        raise Haml::InternalError.new(e.message)
      end
    end
  end
end
