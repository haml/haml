require 'strscan'
require 'temple'
require 'hamlit/parsers/attribute'
require 'hamlit/parsers/comment'
require 'hamlit/parsers/doctype'
require 'hamlit/parsers/filter'
require 'hamlit/parsers/multiline'
require 'hamlit/parsers/script'
require 'hamlit/parsers/tag'
require 'hamlit/parsers/text'

module Hamlit
  class Parser < Temple::Parser
    include Parsers::Attribute
    include Parsers::Comment
    include Parsers::Doctype
    include Parsers::Filter
    include Parsers::Multiline
    include Parsers::Script
    include Parsers::Tag
    include Parsers::Text

    SKIP_NEWLINE_EXPS    = %i[newline code multi].freeze
    SKIP_NEWLINE_FILTERS = %w[ruby markdown erb].freeze

    define_options :format

    def call(template)
      reset(template)

      ast = [:multi]
      ast += parse_lines
      ast
    end

    private

    # Reset the parser state.
    def reset(template)
      validate_indentation_consistency!(template)
      template = replace_hard_tabs(template)
      template = preprocess_multilines(template)

      reset_lines(template.split("\n"))
      reset_indent
      reset_outer_removal
    end

    # Parse lines in current_indent and return ASTs.
    def parse_lines
      ast = []
      loop do
        break if validate_indentation!(ast)

        @current_lineno += 1
        node = parse_line(current_line)
        remove_last_space!(ast) if outer_remove?

        ast << [:newline] if @current_indent > 0
        ast << node
        ast << [:newline] if @current_indent == 0
        ast << [:static, "\n"] unless skip_newline?(node)
      end
      ast
    end

    # Parse current line and return AST.
    def parse_line(line, inline: false)
      return [:multi] if empty_line?(line)

      scanner = wrap_scanner(line)
      scanner.scan(/ +/)

      unless inline
        ast = parse_outer_line(scanner)
        return ast if ast
      end

      parse_inner_line(scanner)
    end

    # Parse a line and return ast if it is acceptable outside an inline tag
    def parse_outer_line(scanner)
      return parse_text(scanner)    if scanner.match?(/\#{/)
      return parse_text(scanner)    if scanner.match?(/[.#]($|[^a-zA-Z0-9_-])/)
      return parse_doctype(scanner) if scanner.match?(/!!!/)

      case scanner.peek(1)
      when '%', '.', '#'
        parse_tag(scanner)
      when '\\'
        parse_text(scanner, scan: /\\/)
      when '/'
        parse_comment(scanner)
      when ':'
        parse_filter(scanner)
      end
    end

    # Parse a line and return ast which is acceptable inside an inline tag
    def parse_inner_line(scanner)
      return parse_text(scanner, lstrip: true)                if scanner.scan(/==/)
      return parse_text(scanner, lstrip: true, escape: false) if scanner.scan(/!==/)
      return parse_text(scanner, lstrip: true, escape: true)  if scanner.scan(/&==/)
      return parse_script(scanner, disable_escape: true)      if scanner.match?(/!=/)
      return parse_script(scanner, force_escape: true)        if scanner.match?(/&=/)

      case scanner.peek(1)
      when '=', '~'
        parse_script(scanner)
      when '-'
        parse_silent_script(scanner)
      when '!'
        parse_text(scanner, lstrip: true, escape: false, scan: /!/)
      when '&'
        parse_text(scanner, lstrip: true, escape: true, scan: /&/)
      else
        parse_text(scanner)
      end
    end

    def skip_newline?(ast)
      SKIP_NEWLINE_EXPS.include?(ast.first) ||
        (ast[0..1] == [:haml, :doctype]) ||
        newline_skip_filter?(ast) ||
        outer_remove?
    end

    def newline_skip_filter?(ast)
      ast[0..1] == [:haml, :filter] && SKIP_NEWLINE_FILTERS.include?(ast[2])
    end

    def wrap_scanner(str)
      return str if str.is_a?(StringScanner)
      StringScanner.new(str)
    end
  end
end
