module Hamlit
  class Filters
    class Coffee < TiltBase
      def compile(node)
        temple = [:multi]
        temple << [:static, "<script>\n".freeze]
        temple << compile_with_tilt(node, 'coffee')
        temple << [:static, "</script>".freeze]
        temple
      end
    end
  end
end
