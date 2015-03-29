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
require 'hamlit/parsers/whitespace'

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
    include Parsers::Whitespace

    SKIP_NEWLINE_EXPS = %i[newline code multi].freeze

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
      template = preprocess_multilines(template)
      reset_lines(template.split("\n"))
      reset_indent
      reset_outer_removal
    end

    # Parse lines in current_indent and return ASTs.
    def parse_lines
      ast = []
      while next_indent == @current_indent
        @current_lineno += 1
        node = parse_line(current_line)
        if @outer_removal.include?(@current_indent) && ast.last == [:static, "\n"]
          ast.delete_at(-1)
        end
        ast << node
        ast << [:newline]
        ast << [:static, "\n"] unless skip_newline?(node)
      end
      ast
    end

    # Parse current line and return AST.
    def parse_line(line)
      return [:multi] if empty_line?(line)

      scanner = StringScanner.new(line)
      scanner.scan(/ +/)
      if scanner.match?(/\#{/)
        return parse_text(scanner)
      elsif scanner.match?(/&=/)
        return parse_script(scanner, force_escape: true)
      elsif scanner.match?(/!=/)
        return parse_script(scanner, disable_escape: true)
      end

      case scanner.peek(1)
      when '!'
        parse_doctype(scanner)
      when '%', '.', '#'
        parse_tag(scanner)
      when '='
        parse_script(scanner)
      when '~'
        parse_preserve(scanner)
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

    def skip_newline?(ast)
      SKIP_NEWLINE_EXPS.include?(ast.first) ||
        (ast[0..1] == [:haml, :doctype]) ||
        @outer_removal.include?(@current_indent)
    end
  end
end
