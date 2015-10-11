require 'haml'

module Hamlit
  class Parser
    OPTION_MAPS = {
      autoclose: :autoclose,
    }.freeze

    def initialize(options = {})
      @options = Haml::Options.defaults.dup
      OPTION_MAPS.each do |temple, haml|
        @options[haml] = options[temple]
      end
    end

    def call(template)
      Haml::Parser.new(template, @options).parse
    end
  end
end
