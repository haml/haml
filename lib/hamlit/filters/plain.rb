require 'haml/util'

module Hamlit
  class Filters
    class Plain < Base
      def initialize(options = {})
        super
        @pretty = options[:pretty]
      end

      def compile(node)
        text = node.value[:text].rstrip
        if Haml::Util.contains_interpolation?(text)
          # FIXME: Confirm whether this is correct or not
          text << "\n".freeze unless @pretty
          text = Haml::Util.unescape_interpolation(text)
          [:escape, true, [:dynamic, text]]
        else
          [:static, text]
        end
      end
    end
  end
end
