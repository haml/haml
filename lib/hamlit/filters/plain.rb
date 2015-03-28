require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Plain < Base
      def compile(lines)
        ast = [:multi]
        text = compile_lines(lines)
        text.gsub!(/\n\Z/, '') unless string_interpolated?(text)
        ast << [:haml, :text, text]
        ast
      end

      private

      def string_interpolated?(text)
        text =~ /\#{[^\#{}]*}/
      end
    end
  end
end
