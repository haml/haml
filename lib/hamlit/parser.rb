require 'haml'

module Hamlit
  class Parser
    def initialize(options = {})
      @options = options
    end

    def call(template)
      Haml::Parser.new(template, {}).parse
    end
  end
end
