require 'temple'

module Hamilton
  class Parser < Temple::Parser
    TAG_ID_CLASS_REGEXP = /[a-zA-Z0-9_-]+/
    EOF = -1

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
      @current_lineno = -1
      @current_indent = 0
    end

    # Parse lines in current_indent and return ASTs.
    def parse_lines
      ast = []
      while next_indent == @current_indent
        @current_lineno += 1
        ast << parse_line(@lines[@current_lineno])
        ast << [:static, "\n"] unless ast.last == [:newline]
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

      attrs = [:html, :attrs]
      attrs += parse_tag_id_and_class(scanner)

      ast = [:html, :tag, tag, attrs]
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

    def parse_tag_id_and_class(scanner)
      ids     = []
      classes = []

      while prefix = scanner.scan(/[#.]/)
        name = scanner.scan(TAG_ID_CLASS_REGEXP)
        raise SyntaxError unless name

        case prefix
        when '#'
          ids << name
        when '.'
          classes << name
        end
      end

      ast = []
      ast << [:html, :attr, 'id', [:static, ids.join(' ')]]        if ids.any?
      ast << [:html, :attr, 'class', [:static, classes.join(' ')]] if classes.any?
      ast
    end

    # Return nearest line's indent level since next line. This method ignores
    # empty line. It returns -1 if next_line does not exist.
    def next_indent
      lineno = @current_lineno + 1
      while @lines[lineno] && empty_line?(@lines[lineno])
        lineno += 1
      end
      return EOF unless @lines[lineno]
      count_indent(@lines[lineno])
    end

    def with_indented(&block)
      @current_indent += 1
      result = block.call
      @current_indent -= 1

      result
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
