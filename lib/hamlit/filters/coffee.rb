require 'hamlit/filters/tilt'

module Hamlit
  module Filters
    class Coffee < Filters::Tilt
      def compile(lines)
        ast = [:html, :tag, 'script', [:html, :attrs]]
        compile_with_tilt('coffee', lines.join("\n"), ast)
      end
    end
  end
end
