module Hamlit
  class FilterCompiler
    class Css < Base
      def compile(node)
        text = compile_text(node.value[:text])
        case @format
        when :xhtml
          compile_xhtml('style', 'text/css', text)
        else
          compile_html('style', text)
        end
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
    end
  end
end
