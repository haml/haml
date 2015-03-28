module Hamlit
  module Filters
    class Css
      def compile(lines)
        ast = [:haml, :text, compile_lines(lines, indent_width: 2)]
        ast = [:multi, [:static, "\n"], ast]
        ast = [:html, :tag, 'style', [:html, :attrs], ast]
        ast
      end

      private

      def compile_lines(lines, indent_width: 0)
        text = strip_last(lines).map { |line|
          ' ' * indent_width + line
        }.join("\n")
        text += "\n" if text.length > 0
        text
      end

      # NOTE: empty line is reserved for preserve filter.
      def strip_last(lines)
        lines = lines.dup
        while lines.last && lines.last.length == 0
          lines.delete_at(-1)
        end
        lines
      end
    end
  end
end
