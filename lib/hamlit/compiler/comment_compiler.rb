module Hamlit
  class Compiler
    class CommentCompiler
      def compile(node, &block)
        if node.children.empty?
          return [:html, :comment, [:static, " #{node.value[:text]} "]]
        end
        [:html, :comment, yield(node)]
      end
    end
  end
end
