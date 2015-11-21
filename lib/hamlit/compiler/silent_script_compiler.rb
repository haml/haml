module Hamlit
  class Compiler
    class SilentScriptCompiler
      def compile(node, &block)
        if node.children.empty?
          [:multi, [:code, node.value[:text]], [:newline]]
        else
          compile_with_children(node, &block)
        end
      end

      private

      def compile_with_children(node, &block)
        temple = [:multi]
        temple << [:code, node.value[:text]]
        temple << [:newline]
        temple << yield(node)
        temple << [:code, 'end']
        temple
      end
    end
  end
end
