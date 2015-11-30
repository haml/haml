module Hamlit
  class Filters
    class Css < TextBase
      def compile(node)
        case @format
        when :xhtml
          compile_xhtml(node)
        else
          compile_html(node)
        end
      end

      private

      def compile_html(node)
        temple = [:multi]
        temple << [:static, "<style>\n".freeze]
        compile_text!(temple, node, '  '.freeze)
        temple << [:static, "\n</style>".freeze]
        temple
      end

      def compile_xhtml(node)
        temple = [:multi]
        temple << [:static, "<style type='text/css'>\n  /*<![CDATA[*/\n".freeze]
        compile_text!(temple, node, '    '.freeze)
        temple << [:static, "\n  /*]]>*/\n</style>".freeze]
        temple
      end
    end
  end
end
