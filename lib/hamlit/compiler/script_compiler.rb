module Hamlit
  class Compiler
    class ScriptCompiler
      def initialize
        @unique_id = 0
      end

      def compile(node, &block)
        code = node.value[:text]
        code = find_and_preserve(code) if node.value[:preserve]

        if node.children.empty?
          temple = [:dynamic, code]
          temple = escape_html(temple) if node.value[:escape_html]
          temple
        else
          var = unique_identifier
          [:multi,
           [:code, "#{var} = #{code}"],
           [:newline],
           yield(node),
           [:code, 'end'.freeze],
           [:dynamic, var],
          ]
        end
      end

      private

      def unique_identifier
        @unique_id += 1
        ['_hamlit_compiler'.freeze, @unique_id].join
      end

      def find_and_preserve(code)
        %Q[Haml::Helpers.find_and_preserve(#{code}, %w(textarea pre code))]
      end

      def escape_html(temple)
        [:escape, true, temple]
      end
    end
  end
end
