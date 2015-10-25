require 'haml'

module Hamlit
  class Parser
    AVAILABLE_OPTIONS = %i[
      autoclose
      escape_html
    ].freeze

    def initialize(options = {})
      @options = Haml::Options.defaults.dup
      AVAILABLE_OPTIONS.each do |key|
        @options[key] = options[key]
      end
    end

    def call(template)
      Haml::Parser.new(template, @options).parse
    end
  end
end
