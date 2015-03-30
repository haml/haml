require 'hamlit/filters/tilt'

module Hamlit
  module Filters
    class Scss < Filters::Tilt
      def compile(lines)
        ast = [:html, :tag, 'style', [:html, :attrs]]
        compile_with_tilt('scss', lines.join("\n"), ast)
      end
    end
  end
end
