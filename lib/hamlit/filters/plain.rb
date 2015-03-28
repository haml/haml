module Hamlit
  module Filters
    class Plain
      def compile(lines)
        ast = [:multi]
        text = lines.join("\n")
        ast << [:haml, :text, text]
        ast << [:static, "\n"] if string_interpolated?(text)
        ast
      end

      private

      def string_interpolated?(text)
        text =~ /\#{[^\#{}]*}/
      end
    end
  end
end
