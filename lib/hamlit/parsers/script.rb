require 'hamlit/concerns/escapable'
require 'hamlit/concerns/error'
require 'hamlit/concerns/included'
require 'hamlit/concerns/indentable'

module Hamlit
  module Parsers
    module Script
      extend Concerns::Included
      include Concerns::Error
      include Concerns::Indentable

      INTERNAL_STATEMENTS    = %w[else elsif when].freeze
      DEFAULT_SCRIPT_OPTIONS = { force_escape: false, disable_escape: false }.freeze

      included do
        include Concerns::Escapable
      end

      def parse_script(scanner, options = {})
        assert_scan!(scanner, /=|&=|!=/)
        options = DEFAULT_SCRIPT_OPTIONS.merge(options)

        code, with_comment = scan_code(scanner, comment_check: true)
        return syntax_error("There's no Ruby code for = to evaluate.") if code.empty? && !with_comment
        unless has_block?
          return [:dynamic, code] if options[:disable_escape]
          return escape_html([:dynamic, code], options[:force_escape])
        end

        ast = [:haml, :script, code, options]
        ast += with_indented { parse_lines }
        ast << [:code, 'end']
        ast
      end

      def parse_preserve(scanner)
        assert_scan!(scanner, /~/)

        code = scan_code(scanner)
        escape_html([:haml, :preserve, code])
      end

      def parse_silent_script(scanner)
        assert_scan!(scanner, /-/)
        if scanner.scan(/#/)
          with_indented { skip_lines }
          return [:multi]
        end

        ast = [:multi, [:code, scan_code(scanner)]]
        unless has_block?
          ast << [:code, 'end'] if @current_indent > next_indent
          return ast
        end

        ast += with_indented { parse_lines }
        ast << [:code, 'end'] unless same_indent?(next_line) && internal_statement?(next_line)
        ast
      end

      private

      def scan_code(scanner, comment_check: false)
        code = ''
        loop do
          code += (scanner.scan(/.+/) || '').strip
          break unless code =~ /,\Z/

          @current_lineno += 1
          scanner = StringScanner.new(current_line)
          code += ' '
        end
        remove_comment(code, comment_check: comment_check)
      end

      def remove_comment(code, comment_check: false)
        result = ''
        with_comment = false
        Ripper.lex(code).each do |(row, col), type, str|
          if type == :on_comment
            with_comment = true
            next
          end
          result += str
        end

        return [result, with_comment] if comment_check
        result
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
