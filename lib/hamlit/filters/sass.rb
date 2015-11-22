module Hamlit
  class Filters
    class Sass < TiltBase
      def compile(node)
        require 'tilt/sass' if explicit_require?
        temple = [:multi]
        temple << [:static, "<style>\n".freeze]
        temple << compile_with_tilt(node, 'sass', indent_width: 2)
        temple << [:static, "</style>".freeze]
        temple
      end
    end
  end
end
