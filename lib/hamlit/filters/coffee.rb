require 'tilt'

module Hamlit
  class Filters
    class Coffee < TiltBase
      def compile(node)
        if Haml::Util.contains_interpolation?(node.value[:text])
          return runtime_compile(node)
        end

        temple = [:multi]
        temple << [:static, "<script>\n".freeze]
        temple << [:static, TiltBase.render('coffee', node.value[:text])]
        temple << [:static, "</script>".freeze]
        temple
      end

      private

      def runtime_compile(node)
        source = Haml::Util.unescape_interpolation(node.value[:text])
        code = "::Hamlit::Filters::TiltBase.render('coffee', #{source})"

        temple = [:multi]
        temple << [:static, "<script>\n".freeze]
        temple << [:dynamic, code]
        temple << [:static, "</script>".freeze]
        temple
      end
    end
  end
end
