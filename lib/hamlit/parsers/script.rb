require 'hamlit/concerns/escapable'
require 'hamlit/concerns/included'
require 'hamlit/concerns/indentable'
require 'hamlit/concerns/syntax_error'

module Hamlit
  module Parsers
    module Script
      extend Concerns::Included
      include Concerns::Indentable
      include Concerns::SyntaxError

      INTERNAL_STATEMENTS = %w[else elsif when].freeze

      included do
        include Concerns::Escapable
      end

      def parse_script(scanner, force_escape: false, disable_escape: false)
        raise SyntaxError unless scanner.scan(/=|&=|!=/)

        code = scan_code(scanner)
        return syntax_error("There's no Ruby code for = to evaluate.") if code.empty?
        unless has_block?
          return [:dynamic, code] if disable_escape
          return escape_html([:dynamic, code], force_escape)
        end

        # FIXME: parse != or &= for block
        ast = [:haml, :script, code]
        ast += with_indented { parse_lines }
        ast << [:code, 'end']
        ast
      end

      def parse_preserve(scanner)
        raise SyntaxError unless scanner.scan(/~/)

        code = scan_code(scanner)
        escape_html([:haml, :preserve, code])
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

      private

      def scan_code(scanner)
        code = ''
        loop do
          code += (scanner.scan(/.+/) || '').strip
          break unless code =~ /,\Z/

          @current_lineno += 1
          scanner = StringScanner.new(current_line)
          code += ' '
        end
        code
      end

      def has_block?
        next_indent == @current_indent + 1
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
    end
  end
end
