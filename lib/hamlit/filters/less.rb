require 'hamlit/filters/tilt'

module Hamlit
  module Filters
    class Less < Filters::Tilt
      def compile(lines)
        ast = [:html, :tag, 'style', [:html, :attrs]]
        compile_with_tilt('less', lines.join("\n"), ast)
      end
    end
  end
end
