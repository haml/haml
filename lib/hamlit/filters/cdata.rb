module Hamlit
  class Filters
    class Cdata < TextBase
      def compile(node)
        compile_cdata(node)
      end

      private

      def compile_cdata(node)
        temple = [:multi]
        temple << [:static, "<![CDATA[\n".freeze]
        compile_text!(temple, node, '  '.freeze)
        temple << [:static, "\n]]>".freeze]
        temple
      end
    end
  end
end
