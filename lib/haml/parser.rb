# frozen_string_literal: true
# Haml::Parser uses original Haml::Parser to generate Haml AST.
# haml/parser/haml_* are modules originally in haml gem.

require 'haml/parser/haml_attribute_builder'
require 'haml/parser/haml_error'
require 'haml/parser/haml_util'
require 'haml/parser/haml_helpers'
require 'haml/parser/haml_buffer'
require 'haml/parser/haml_compiler'
require 'haml/parser/haml_parser'
require 'haml/parser/haml_options'
require 'haml/parser/haml_escapable'
require 'haml/parser/haml_generator'
require 'haml/parser/haml_temple_engine'

module Haml
  class Parser
    AVAILABLE_OPTIONS = %i[
      autoclose
      escape_html
      escape_attrs
    ].freeze

    def initialize(options = {})
      @options = HamlOptions.defaults.dup
      AVAILABLE_OPTIONS.each do |key|
        @options[key] = options[key]
      end
    end

    def call(template)
      template = Haml::HamlUtil.check_haml_encoding(template) do |msg, line|
        raise Haml::Error.new(msg, line)
      end
      HamlParser.new(HamlOptions.new(@options)).call(template)
    rescue ::Haml::HamlError => e
      error_with_lineno(e)
    end

    private

    def error_with_lineno(error)
      return error if error.line

      trace = error.backtrace.first
      return error unless trace

      line = trace.match(/\d+\z/).to_s.to_i
      HamlSyntaxError.new(error.message, line)
    end
  end
end
