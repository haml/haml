require 'temple'

module Hamilton
  class Parser < Temple::Parser
    def call(template)
      reset(template)

      ast = [:multi]
      ast += parse_lines
      ast
    end

    private

    # Reset the parser state.
    def reset(template)
      @lines = template.split("\n")
      @current_lineno = 0
      @current_indent = 0
    end

    # Parse lines in current_indent and return ASTs.
    def parse_lines
      ast = []
      while nearest_indent == @current_indent
        ast << parse_line(current_line)
        ast << [:static, "\n"]
        @current_lineno += 1
      end
      ast
    end

    # Parse current line and return AST.
    def parse_line(line)
      return [:newline] if empty_line?(line)

      scanner = StringScanner.new(line)
      scanner.scan(/ +/)

      case scanner.peek(1)
      when '!'
        parse_doctype(scanner)
      when '%'
        parse_tag(scanner)
      else
        parse_text(scanner)
      end
    end

    def parse_doctype(scanner)
      raise SyntaxError unless scanner.scan(/!!!/)

      [:html, :doctype, 'html']
    end

    def parse_tag(scanner)
      raise SyntaxError unless scanner.scan(/%/)

      tag = scanner.scan(/[a-z]+/)
      raise SyntaxError unless tag

      ast = [:html, :tag, tag, [:html, :attrs]]

      if scanner.scan(/ +/) && text = scanner.scan(/.+/)
        ast << [:static, text]
        return ast
      end
      return ast if next_indent <= @current_indent

      content = [:multi, [:static, "\n"]]
      content += with_indented { parse_lines }
      ast << content
      ast
    end

    def parse_text(scanner)
      ast = [:static]
      ast << scanner.scan(/.+/)
      ast
    end

    # Return nearest line's indent level. This method ignores empty line.
    def nearest_indent(lineno = @current_lineno)
      while @lines[lineno] && empty_line?(@lines[lineno])
        lineno += 1
      end
      @lines[lineno] && count_indent(@lines[lineno])
    end

    # Return nearest line's indent level since next line.
    def next_indent
      nearest_indent(@current_lineno + 1)
    end

    def with_indented(&block)
      @current_lineno += 1
      @current_indent += 1
      result = block.call
      @current_indent -= 1

      result
    end

    def current_line
      @lines[@current_lineno]
    end

    def count_indent(line)
      width = line[/\A +/].to_s.length
      raise SyntaxError if width.odd?

      width / 2
    end

    def empty_line?(line)
      line =~ /\A *\Z/
    end
  end
end
