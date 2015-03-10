require 'temple'

module Hamilton
  class Parser < Temple::Parser
    def initialize(options = {})
      super
      @template_ast = [:multi]
      @stack        = []
      @prev_indent  = 0
    end

    def call(template)
      template.each_line do |line|
        scanner = StringScanner.new(line)
        @indent = parse_indent(scanner)

        ast = parse_line(scanner)
        @stack.push(ast) if ast

        @prev_indent = @indent
      end

      ast = compile_stack
      @template_ast << ast if ast

      @template_ast
    end

    private

    def parse_indent(scanner)
      spaces = scanner.scan(/ +/) || ''
      raise SyntaxError if spaces.size.odd?

      spaces.size / 2
    end

    def parse_line(scanner)
      case scanner.scan(/./)
      when '!'
        parse_doctype(scanner)
      when '%'
        parse_element(scanner)
      else
        scanner.unscan
        parse_text(scanner)
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

    def parse_text(scanner)
      text = scanner.scan(/.+/)
      return nil unless text

      [:static, text]
    end

    def compile_stack
      return nil if @stack.empty?

      ast = @stack.pop
      while parent = @stack.pop
        parent << ast
        ast = parent
      end
      ast
    end
  end
end
