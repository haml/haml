module Hamlit
  class Filters
    class Css < Base
      def compile(node)
        text = compile_text(node.value[:text])
        case @format
        when :xhtml
          compile_xhtml('style', 'text/css', text)
        else
          compile_html('style', text)
        end
      end
    end
  end
end
