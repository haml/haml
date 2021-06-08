# frozen_string_literal: true
require 'haml/utils'

module Haml
  class Escapable < Temple::Filters::Escapable
    def initialize(opts = {})
      super
      @escape_code = options[:escape_code] ||
        "::Haml::Utils.escape_html#{options[:use_html_safe] ? '_safe' : ''}((%s))"
      @escaper = eval("proc {|v| #{@escape_code % 'v'} }")
    end
  end
end
