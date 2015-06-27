require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Css < Base
      def compile(lines)
        if options[:format] == :xhtml
          return compile_xhtml('style', 'text/css', lines)
        end

        compile_html('style', lines)
      end
    end
  end
end
