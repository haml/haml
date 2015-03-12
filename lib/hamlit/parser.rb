require 'temple'
require 'hamlit/parser/utils'

module Hamlit
  class Parser
    include Utils

    TAG_ID_CLASS_REGEXP = /[a-zA-Z0-9_-]+/
    INTERNAL_STATEMENTS = %w[else elsif when].freeze
    SKIP_NEWLINE_EXPS   = %i[newline code multi].freeze
    TAG_REGEXP  = /[a-z]+/
    DEFAULT_TAG = 'div'

    def call(template)
      reset(template)

      ast = [:multi]
      ast += parse_lines
      ast
    end

    private

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
