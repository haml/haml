module Hamlit
  class Compiler
    def initialize(options = {})
      @options = options
    end

    def compile(node)
      case node.type
      when :root
        compile_children(node)
      when :tag
        [:html, :tag, node.value[:name], [:html, :attrs], [:multi]]
      else
        [:static, "\n"]
      end
    end
    alias :call :compile

    private

    def compile_children(node)
      temple = node.children.map { |n| compile(n) }
      [:multi, *temple]
    end
  end
end
