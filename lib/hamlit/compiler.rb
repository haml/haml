module Hamlit
  class Compiler
    def initialize(options = {})
      @options = options
    end

    def call(ast)
      temple = ast.children.map do |node|
        compile_node(node)
      end
      [:multi, *temple]
    end

    private

    def compile_node(node)
      case node.type
      when :tag
        [:html, :tag, node.value[:name], [:html, :attrs], [:multi]]
      else
        [:static, "\n"]
      end
    end
  end
end
