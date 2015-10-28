module Hamlit
  class Filters
    class Markdown < TiltBase
      def compile(node)
        compile_with_tilt(node, 'markdown')
      end
    end
  end
end
