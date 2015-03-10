require 'temple'

module Hamilton
  class Parser < Temple::Parser
    def initialize(options = {})
      super
      @template_ast = [:multi]
    end

    def call(template)
      template.each_line do |line|
        @template_ast << parse_line(line)
      end
      @template_ast
    end

    private

    def parse_line(line)
      scanner = StringScanner.new(line)
      case scanner.scan(/./)
      when '!'
        parse_doctype(scanner)
      when '%'
        parse_element(scanner)
      end
    end

    def parse_doctype(scanner)
      raise SyntaxError unless scanner.scan(/!!/)

      [:html, :doctype, 'html']
    end

    def parse_element(scanner)
      tag = scanner.scan(/[a-z]+/)
      raise SyntaxError unless tag

      ast = [:html, :tag, tag, [:html, :attrs]]
      if scanner.scan(/ /)
        text = scanner.scan(/.+/)
        ast << [:static, text]
      end
      ast
    end
  end
end
