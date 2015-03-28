module Hamlit
  module Filters
    class Plain
      def compile(lines)
        ast = [:multi]
        text = strip_last(lines).join("\n")
        ast << [:haml, :text, text]
        ast << [:static, "\n"] if string_interpolated?(text)
        ast
      end

      private

      def string_interpolated?(text)
        text =~ /\#{[^\#{}]*}/
      end

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
