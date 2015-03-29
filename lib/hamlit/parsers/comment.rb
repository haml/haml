require 'hamlit/concerns/error'
require 'hamlit/concerns/indentable'

module Hamlit
  module Parsers
    module Comment
      include Concerns::Indentable

      def parse_comment(scanner)
        assert_scan!(scanner, /\//)

        ast = [:html, :comment]
        text = (scanner.scan(/.+/) || '').strip

        if text.empty?
          content = with_indented { parse_lines }
          return ast << [:multi, [:static, "\n"], *content]
        elsif !text.match(/\[.*\]/)
          return ast << [:static, " #{text} "]
        end

        content = with_indented { parse_lines }
        [:haml, :comment, text, content]
      end
    end
  end
end
