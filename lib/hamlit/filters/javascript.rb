require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Javascript < Base
      def compile(lines)
        ast = [:haml, :text, compile_lines(lines, indent_width: 2)]
        ast = [:multi, [:static, "\n"], ast]
        ast = [:html, :tag, 'script', [:html, :attrs], ast]
        ast
      end
    end
  end
end
