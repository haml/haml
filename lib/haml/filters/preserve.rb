# frozen_string_literal: true
module Haml
  class Filters
    class Preserve < Base
      def compile(node)
        text = node.value[:text].rstrip + "\n"
        text = text.gsub("\n", '&#x000A;')
        compile_text(text)
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
