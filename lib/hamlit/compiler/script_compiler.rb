module Hamlit
  class Compiler
    class ScriptCompiler
      def compile(node)
        code = node.value[:text]
        code = find_and_preserve(code) if node.value[:preserve]

        temple = [:dynamic, code]
        temple = escape_html(temple) if node.value[:escape_html]
        temple
      end

      private

      def find_and_preserve(code)
        %Q[Haml::Helpers.find_and_preserve(#{code}, %w(textarea pre code))]
      end

      def escape_html(temple)
        [:escape, true, temple]
      end
    end
  end
end
