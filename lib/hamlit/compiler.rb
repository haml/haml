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
        compile_tag(node)
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

    def compile_tag(node)
      attrs = [:html, :attrs]
      node.value[:attributes].each do |name, value|
        attrs << [:html, :attr, name, [:static, value]]
      end
      [:html, :tag, node.value[:name], attrs, [:multi]]
    end
  end
end
