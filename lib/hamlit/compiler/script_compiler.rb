module Hamlit
  class Compiler
    class ScriptCompiler
      def initialize
        @unique_id = 0
      end

      def compile(node, &block)
        var = unique_identifier
        temple = compile_script_assign(var, node, &block)
        temple << compile_script_result(var, node)
      end

      private

      def compile_script_assign(var, node, &block)
        if node.children.empty?
          [:multi,
           [:code, "#{var} = (#{node.value[:text]}"],
           [:newline],
           [:code, ')'.freeze],
          ]
        else
          [:multi,
           [:code, "#{var} = #{node.value[:text]}"],
           [:newline],
           yield(node),
           [:code, 'end'.freeze],
          ]
        end
      end

      def compile_script_result(result, node)
        if !node.value[:escape_html] && node.value[:preserve]
          result = find_and_preserve(result)
        else
          result = '(' << result << ').to_s'.freeze
        end
        [:escape, node.value[:escape_html], [:dynamic, result]]
      end

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
