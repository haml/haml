module Hamlit
  class Compiler
    class SilentScriptCompiler
      def compile(node)
        [:code, node.value[:text]]
      end
    end
  end
end
