require 'strscan'
require 'temple'
require 'hamlit/concerns/balanceable'
require 'hamlit/concerns/escapable'
require 'hamlit/concerns/indentable'
require 'hamlit/concerns/line_reader'

module Hamlit
  class Parser < Temple::Parser
    include Concerns::Balanceable
    include Concerns::Escapable
    include Concerns::Indentable
    include Concerns::LineReader

    TAG_ID_CLASS_REGEXP = /[a-zA-Z0-9_-]+/
    INTERNAL_STATEMENTS = %w[else elsif when].freeze
    SKIP_NEWLINE_EXPS   = %i[newline code multi].freeze
    TAG_REGEXP  = /[a-zA-Z0-9\-_]+/
    DEFAULT_TAG = 'div'

    def call(template)
      reset(template)

      ast = [:multi]
      ast += parse_lines
      ast
    end

    private

    # Reset the parser state.
    def reset(template)
      reset_lines(template.split("\n"))
      reset_indent
    end

    # Parse lines in current_indent and return ASTs.
    def parse_lines
      ast = []
      while next_indent == @current_indent
        @current_lineno += 1
        ast << parse_line(current_line)
        ast << [:static, "\n"] unless skip_newline?(ast.last)
        ast << [:newline]
      end
      ast
    end

    # Parse current line and return AST.
    def parse_line(line)
      return [:newline] if empty_line?(line)

      scanner = StringScanner.new(line)
      scanner.scan(/ +/)
      return parse_text(scanner) if scanner.match?(/\#{/)

      case scanner.peek(1)
      when '!'
        parse_doctype(scanner)
      when '%', '.', '#'
        parse_tag(scanner)
      when '='
        parse_script(scanner)
      when '-'
        parse_silent_script(scanner)
      when '/'
        parse_comment(scanner)
      when ':'
        parse_filter(scanner)
      else
        parse_text(scanner)
      end
    end

    def parse_doctype(scanner)
      raise SyntaxError unless scanner.scan(/!!!/)

      type = nil
      if scanner.scan(/ +/) && scanner.rest?
        type = scanner.rest.strip
      end

      [:haml, :doctype, options[:format], type]
    end

    def parse_tag(scanner)
      tag = DEFAULT_TAG
      tag = scanner.scan(TAG_REGEXP) if scanner.scan(/%/)

      attrs = [:haml, :attrs]
      attrs += parse_tag_id_and_class(scanner)
      attrs += parse_attributes(scanner)

      ast = [:html, :tag, tag, attrs]

      if scanner.match?(/=/)
        ast << parse_script(scanner)
        return ast
      elsif scanner.rest.match(/[^ ]/)
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

      code = scan_code(scanner)
      return escape_html([:dynamic, code]) unless has_block?

      ast = [:haml, :script, code]
      ast += with_indented { parse_lines }
      ast << [:code, 'end']
      ast
    end

    def parse_silent_script(scanner)
      raise SyntaxError unless scanner.scan(/-/)
      if scanner.scan(/#/)
        with_indented { skip_lines }
        return [:newline]
      end

      ast = [:code]
      ast << scan_code(scanner)
      return ast unless has_block?

      ast = [:multi, ast]
      ast += with_indented { parse_lines }
      ast << [:code, 'end'] unless same_indent?(next_line) && internal_statement?(next_line)
      ast
    end

    def parse_comment(scanner)
      raise SyntaxError unless scanner.scan(/\//)

      ast = [:html, :comment]
      ast << [:static, " #{scanner.scan(/.+/).strip} "]
      ast
    end

    def parse_filter(scanner)
      raise SyntaxError unless scanner.scan(/:/)

      name = scanner.scan(/.+/).strip
      lines = with_indented { read_lines }
      [:haml, :filter, name, lines]
    end

    def parse_text(scanner)
      ast = [:haml, :text]
      ast << scanner.scan(/.+/).strip
      ast
    end

    def parse_attributes(scanner)
      if scanner.match?(/{/)
        parse_old_attributes(scanner)
      else
        parse_new_attributes(scanner)
      end
    end

    def parse_old_attributes(scanner)
      [read_braces(scanner)].compact
    end

    def parse_new_attributes(scanner)
      [read_parentheses(scanner)].compact
    end

    def parse_tag_id_and_class(scanner)
      attributes = Hash.new { |h, k| h[k] = [] }

      while prefix = scanner.scan(/[#.]/)
        name = scanner.scan(TAG_ID_CLASS_REGEXP)
        raise SyntaxError unless name

        case prefix
        when '#'
          attributes['id'] << name
        when '.'
          attributes['class'] << name
        end
      end

      ast = []
      attributes.each do |name, values|
        ast << [:html, :attr, name, [:static, values.join(' ')]]
      end
      ast
    end

    def internal_statement?(line)
      return false unless line

      scanner = StringScanner.new(line)
      scanner.scan(/ +/)
      return false unless scanner.scan(/-/)

      scanner.scan(/ +/)
      statement = scanner.scan(/[^ ]+/)
      INTERNAL_STATEMENTS.include?(statement)
    end

    def skip_newline?(ast)
      SKIP_NEWLINE_EXPS.include?(ast.first)
    end

    def has_block?
      next_indent == @current_indent + 1
    end

    def scan_code(scanner)
      code = ''
      loop do
        code += scanner.scan(/.+/).strip
        break unless code =~ /,\Z/

        @current_lineno += 1
        scanner = StringScanner.new(current_line)
        code += ' '
      end
      code
    end
  end
end
