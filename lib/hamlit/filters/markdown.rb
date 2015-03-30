require 'hamlit/filters/tilt'

module Hamlit
  module Filters
    class Markdown < Filters::Tilt
      def compile(lines)
        compile_with_tilt('markdown', lines.join("\n"), [], indent_width: 0)
      end
    end
  end
end
