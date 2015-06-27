require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Javascript < Base
      def compile(lines)
        if options[:format] == :xhtml
          return compile_xhtml('script', 'text/javascript', lines)
        end

        compile_html('script', lines)
      end
    end
  end
end
