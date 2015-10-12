module Hamlit
  class Filters
    class Javascript < Base
      def compile(node)
        text = compile_text(node.value[:text])
        case @format
        when :xhtml
          compile_xhtml('script', 'text/javascript', text)
        else
          compile_html('script', text)
        end
      end
    end
  end
end
