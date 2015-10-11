module Hamlit
  class Compiler
    def initialize(options = {})
      @options = options
    end

    def call(ast)
      compile(ast)
    end

    private

    def compile(node)
      case node.type
      when :root
        compile_children(node)
      when :doctype
        compile_doctype(node)
      when :tag
        compile_tag(node)
      when :plain
        compile_plain(node)
      else
        [:static, "\n"]
      end
    end

    def compile_children(node)
      temple = node.children.map { |n| compile(n) }
      [:multi, *temple]
    end

    def compile_doctype(node)
      [:html, :doctype, node.value[:type]]
    end

    def compile_tag(node)
      attrs = [:html, :attrs]
      node.value[:attributes].each do |name, value|
        attrs << [:html, :attr, name, [:static, value]]
      end
      [:html, :tag, node.value[:name], attrs, compile_children(node)]
    end

    def compile_plain(node)
      [:static, node.value[:text]]
    end
  end
end
