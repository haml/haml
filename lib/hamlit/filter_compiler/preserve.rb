require 'haml/util'

module Hamlit
  class FilterCompiler
    class Preserve
      def compile(node)
        text = node.value[:text].rstrip + "\n"
        text = text.gsub("\n", '&#x000A;') + "\n"
        compile_text(text)
      end

      private

      def compile_text(text)
        if Haml::Util.contains_interpolation?(text)
          [:dynamic, Haml::Util.unescape_interpolation(text + "\n")]
        else
          [:static, text]
        end
      end
    end
  end
end
