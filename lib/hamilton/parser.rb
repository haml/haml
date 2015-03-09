require 'temple'

module Hamilton
  class Parser < Temple::Parser
    def initialize(options = {})
      super
      @ast = [:multi]
    end

    def call(template)
      template.each_line do |line|
        parse_line(line)
      end
      @ast
    end

    private

    def parse_line(line)
      case line
      when /\A!!!/
        @ast << [:html, :doctype, 'html']
      end
    end
  end
end
