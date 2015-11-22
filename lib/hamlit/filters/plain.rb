module Hamlit
  class Filters
    class Plain < Base
      def compile(node)
        text = node.value[:text].rstrip
        if ::Hamlit::HamlUtil.contains_interpolation?(text)
          # FIXME: Confirm whether this is correct or not
          text << "\n".freeze
          text = ::Hamlit::HamlUtil.slow_unescape_interpolation(text)
          [:escape, true, [:dynamic, text]]
        else
          [:static, text]
        end
      end
    end
  end
end
