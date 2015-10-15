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
          if @pretty
            [:dynamic, Haml::Util.unescape_interpolation(text)]
          else
            [:dynamic, Haml::Util.unescape_interpolation(text + "\n")]
          end
        else
          [:static, text]
        end
      end
    end
  end
end
