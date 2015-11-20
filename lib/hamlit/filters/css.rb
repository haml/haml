module Hamlit
  class Filters
    class Css < Base
      def compile(node)
        case @format
        when :xhtml
          compile_xhtml(node)
        else
          compile_html(node)
        end
      end

      private

      def compile_text!(temple, node, prefix)
        (node.value[:text].rstrip << "\n").each_line do |line|
          if ::Hamlit::HamlUtil.contains_interpolation?(line)
            temple << [:dynamic, ::Hamlit::HamlUtil.unescape_interpolation(prefix.dup << line)]
          else
            temple << [:static, prefix.dup << line]
          end
          temple << [:newline]
        end
      end

      def compile_html(node)
        temple = [:multi]
        temple << [:static, "<style>\n".freeze]
        compile_text!(temple, node, '  '.freeze)
        temple << [:static, '</style>'.freeze]
        temple
      end

      def compile_xhtml(node)
        temple = [:multi]
        temple << [:static, "<style type='text/css'>\n  /*<![CDATA[*/\n".freeze]
        compile_text!(temple, node, '    '.freeze)
        temple << [:static, "  /*]]>*/\n</style>".freeze]
        temple
      end
    end
  end
end
