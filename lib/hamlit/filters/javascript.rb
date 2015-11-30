module Hamlit
  class Filters
    class Javascript < TextBase
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
        temple << [:static, "<script>\n".freeze]
        compile_text!(temple, node, '  '.freeze)
        temple << [:static, "\n</script>".freeze]
        temple
      end

      def compile_xhtml(node)
        temple = [:multi]
        temple << [:static, "<script type='text/javascript'>\n  //<![CDATA[\n".freeze]
        compile_text!(temple, node, '    '.freeze)
        temple << [:static, "\n  //]]>\n</script>".freeze]
        temple
      end
    end
  end
end
