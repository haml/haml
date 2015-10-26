require 'tilt'

module Hamlit
  class Filters
    class Coffee < TiltBase
      def compile(node)
        temple = [:multi]
        temple << [:static, "<script>\n".freeze]
        temple << [:static, TiltBase.render('coffee', node.value[:text])]
        temple << [:static, "</script>".freeze]
        temple
      end
    end
  end
end
