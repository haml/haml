require 'haml/util'

module Hamlit
  class FilterCompiler
    class Plain
      def compile(node)
        text = node.value[:text].rstrip + "\n"
        if Haml::Util.contains_interpolation?(text)
          [:dynamic, Haml::Util.unescape_interpolation(text + "\n")]
        else
          [:static, text]
        end
      end
    end
  end
end
