require 'hamlit/filters/tilt'

module Hamlit
  module Filters
    class Erb < Filters::Tilt
      def compile(lines)
        compile_with_tilt('erb', lines.join("\n"), [], indent_width: 0)
      end
    end
  end
end
