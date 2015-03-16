module Hamlit
  module Filters
    class Javascript
      def compile(lines)
        lines = [''] if lines.empty?
        lines = unindent_lines(lines)

        ast = [:multi, [:static, "\n"], *insert_newlines(lines)]
        ast = [:html, :tag, 'script', [:html, :attrs], [:html, :js, ast]]
        ast
      end

      private

      def unindent_lines(lines)
        base = lines.first.index(/[^\s]/) || 0
        lines.map do |line|
          change_indent(line, 2 - base)
        end
      end

      def change_indent(line, diff)
        if diff >= 0
          ((' ' * diff) + line).gsub(/ *\Z/, '')
        else
          line.gsub(/^[[:blank:]]{#{-1 * diff}}/, '')
        end
      end

      def insert_newlines(lines)
        ast = []
        lines.each do |line|
          ast << [:static, line]
          ast << [:static, "\n"]
        end
        ast
      end
    end
  end
end
