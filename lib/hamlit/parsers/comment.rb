module Hamlit
  module Parsers
    module Comment
      def parse_comment(scanner)
        raise SyntaxError unless scanner.scan(/\//)

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
