require 'temple'

module Hamilton
  class Parser < Temple::Parser
    TAG_ID_CLASS_REGEXP = /[a-zA-Z0-9_-]+/
    INTERNAL_STATEMENTS = %w[else elsif when].freeze
    SKIP_NEWLINE_EXPS   = %i[newline code multi].freeze
    TAG_REGEXP  = /[a-z]+/
    DEFAULT_TAG = 'div'
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
        ast << [:static, "\n"] unless skip_newline?(ast.last)
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
      when '%', '.', '#'
        parse_tag(scanner)
      when '='
        parse_script(scanner)
      when '-'
        parse_silent_script(scanner)
      else
        parse_text(scanner)
      end
    end

    def parse_doctype(scanner)
      raise SyntaxError unless scanner.scan(/!!!/)

      [:html, :doctype, 'html']
    end

    def parse_tag(scanner)
      tag = DEFAULT_TAG
      tag = scanner.scan(TAG_REGEXP) if scanner.scan(/%/)

      attrs = [:html, :attrs]
      attrs += parse_tag_id_and_class(scanner)

      ast = [:html, :tag, tag, attrs]

      if scanner.match?(/=/)
        ast << parse_script(scanner)
        return ast
      elsif scanner.scan(/ +/) && scanner.rest?
        ast << parse_text(scanner)
        return ast
      elsif next_indent <= @current_indent
        return ast
      end

      content = [:multi, [:static, "\n"]]
      content += with_indented { parse_lines }
      ast << content
      ast
    end

    def parse_script(scanner)
      raise SyntaxError unless scanner.scan(/=/)

      ast = [:dynamic]
      ast << scanner.scan(/.+/)
      ast
    end

    def parse_silent_script(scanner)
      raise SyntaxError unless scanner.scan(/-/)

      ast = [:code]
      ast << scanner.scan(/.+/)
      return ast if next_indent != @current_indent + 1

      ast = [:multi, ast]
      ast += with_indented { parse_lines }
      ast << [:code, 'end'] unless internal_statement?(next_line)
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
      line = next_line
      return EOF unless line

      count_indent(line)
    end

    # Return nearest line ignoring empty lines.
    def next_line
      lineno = @current_lineno + 1
      while @lines[lineno] && empty_line?(@lines[lineno])
        lineno += 1
      end
      @lines[lineno]
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

    def internal_statement?(line)
      return false unless line

      scanner = StringScanner.new(line)
      return false unless scanner.scan(/-/)

      scanner.scan(/ +/)
      statement = scanner.scan(/[^ ]+/)
      INTERNAL_STATEMENTS.include?(statement)
    end

    def skip_newline?(ast)
      SKIP_NEWLINE_EXPS.include?(ast.first)
    end
  end
end
