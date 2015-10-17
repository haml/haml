module Hamlit
  class Compiler
    class ScriptCompiler
      def compile(node)
        if node.value[:preserve]
          [:dynamic, %Q[Haml::Helpers.find_and_preserve(#{node.value[:text]}, %w(textarea pre code))]]
        elsif node.value[:escape_html]
          [:escape, true, [:dynamic, node.value[:text]]]
        else
          [:dynamic, node.value[:text]]
        end
      end
    end
  end
end
