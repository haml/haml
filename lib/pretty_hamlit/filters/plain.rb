require 'hamlit/filters/plain'

module PrettyHamlit
  class Filters
    class Plain < Hamlit::Filters::Plain
      def compile(node)
        text = node.value[:text].rstrip
        if Haml::Util.contains_interpolation?(text)
          text = Haml::Util.unescape_interpolation(text)
          [:escape, true, [:dynamic, text]]
        else
          [:static, text]
        end
      end
    end
  end
end
