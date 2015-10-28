require 'tilt'

module Hamlit
  class Filters
    class Less < TiltBase
      def compile(node)
        if Haml::Util.contains_interpolation?(node.value[:text])
          return runtime_compile(node)
        end

        temple = [:multi]
        temple << [:static, "<style>\n".freeze]
        temple << [:static, TiltBase.render('less', node.value[:text])]
        temple << [:static, "</style>".freeze]
        temple
      end

      private

      def runtime_compile(node)
        source = Haml::Util.unescape_interpolation(node.value[:text])
        code = "::Hamlit::Filters::TiltBase.render('less', #{source})"

        temple = [:multi]
        temple << [:static, "<style>\n".freeze]
        temple << [:dynamic, code]
        temple << [:static, "</style>".freeze]
        temple
      end
    end
  end
end
