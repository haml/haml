require 'haml/util'

module Hamlit
  class Filters
    class Base
      def initialize(options = {})
        @format = options[:format]
      end

      private

      def compile_text(text)
        text = text.rstrip + "\n"
        case @format
        when :xhtml
          text.prepend('    ')
        else
          text.prepend('  ')
        end
      end

      def compile_html(tag, text)
        temple = [:multi, [:static, "\n"], [:static, text]]
        temple = [:html, :tag, tag, [:html, :attrs], temple]
        temple
      end

      def compile_xhtml(tag, type, text)
        attr  = [:html, :attr, 'type', [:static, type]]
        attrs = [:html, :attrs, attr]

        multi = [:multi, [:static, "\n"], *cdata_for(type, [:static, text])]
        [:html, :tag, tag, attrs, multi]
      end

      def cdata_for(type, ast)
        case type
        when 'text/javascript'
          [[:static, "  //<![CDATA[\n"], ast, [:static, "  //]]>\n"]]
        when 'text/css'
          [[:static, "  /*<![CDATA[*/\n"], ast, [:static, "  /*]]>*/\n"]]
        end
      end
    end
  end
end
