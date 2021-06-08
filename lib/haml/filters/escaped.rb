# frozen_string_literal: true
module Haml
  class Filters
    class Escaped < Base
      def compile(node)
        text = node.value[:text].rstrip
        temple = compile_text(text)
        [:escape, true, temple]
      end

      private

      def compile_text(text)
        if ::Haml::HamlUtil.contains_interpolation?(text)
          [:dynamic, ::Haml::HamlUtil.unescape_interpolation(text)]
        else
          [:static, text]
        end
      end
    end
  end
end
