# frozen_string_literal: true
require 'ripper'
require 'temple/static_analyzer'

module Haml
  class RubyExpression < Ripper
    class ParseError < StandardError; end

    # Necessary condition for a string literal: a quote or %q/%Q. Cheap gate before Ripper.
    STRING_LITERAL_START = /\A\s*(?:["']|%[qQ]?[({\[|!<~])/

    def self.syntax_error?(code)
      self.new(code).parse
      false
    rescue ParseError
      true
    end

    def self.string_literal?(code)
      return false unless STRING_LITERAL_START.match?(code)

      # Ripper.sexp already returns nil on syntax errors, so no separate syntax_error? check.
      type, instructions = Ripper.sexp(code)
      return false if type != :program
      return false if instructions.size > 1

      type, _ = instructions.first
      type == :string_literal
    end

    private

    def on_parse_error(*)
      raise ParseError
    end
  end

  # Necessary condition for a static expression. A non-match skips Temple's Ripper parse.
  module StaticAnalyzerPrefilter
    STATIC_START = /\A\s*(?:["'\[({:\d]|%[qQwWiI]?[({\[|!<~]|true[\s)\]}]*\z|false[\s)\]}]*\z|nil[\s)\]}]*\z)/
    def static?(code)
      return false if code.nil?
      return false unless STATIC_START.match?(code)
      super
    end
  end
end

Temple::StaticAnalyzer.singleton_class.prepend(Haml::StaticAnalyzerPrefilter)
