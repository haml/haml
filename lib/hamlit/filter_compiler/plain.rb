module Hamlit
  class FilterCompiler
    class Plain
      def compile(node)
        [:static, node.value[:text].rstrip + "\n"]
      end
    end
  end
end
