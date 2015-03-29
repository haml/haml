require 'hamlit/concerns/included'
require 'hamlit/concerns/escapable'

module Hamlit
  module Parsers
    module Script
      extend Concerns::Included

      included do
        include Concerns::Escapable
      end

      def parse_script(scanner, force_escape: false, disable_escape: false)
        raise SyntaxError unless scanner.scan(/=|&=|!=/)

        code = scan_code(scanner)
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
end
