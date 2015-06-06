require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Javascript < Base
      def compile(lines)
        return compile_xhtml(lines) if options[:format] == :xhtml

        compile_html(lines)
      end

      private

      def compile_html(lines)
        ast = [:haml, :text, compile_lines(lines, indent_width: 2), false]
        ast = [:multi, [:static, "\n"], ast]
        ast = [:html, :tag, 'script', [:html, :attrs], ast]
        ast
      end

      def compile_xhtml(lines)
        attr  = [:html, :attr, 'type', [:static, 'text/javascript']]
        attrs = [:html, :attrs, attr]

        multi = [:multi, [:static, "\n"]]
        multi << [:static, "  //<![CDATA[\n"]
        multi << [:haml, :text, compile_lines(lines, indent_width: 4)]
        multi << [:static, "  //]]>\n"]

        [:html, :tag, 'script', attrs, multi]
      end
    end
  end
end
