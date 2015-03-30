require 'tilt'
require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Sass < Base
      def compile(lines)
        result  = compile_with_tilt(lines)
        content = [:multi, [:static, "\n"], result]
        [:html, :tag, 'style', [:html, :attrs], content]
      end

      private

      def compile_with_tilt(lines)
        source = lines.join("\n")
        result = ::Tilt['t.sass'].new { source }.render
        [:static, compile_lines(result.split("\n"), indent_width: 2)]
      end
    end
  end
end
