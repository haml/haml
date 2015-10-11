require 'hamlit/tag_compiler'

module Hamlit
  class Compiler
    def initialize(options = {})
      @tag_compiler = TagCompiler.new(options[:attr_quote])
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
        [:multi]
      end
    end

    def compile_children(node)
      temple = [:multi]
      node.children.each do |n|
        temple << compile(n)
        temple << [:static, "\n"] if insert_whitespace?(n)
      end
      temple
    end

    def compile_doctype(node)
      [:html, :doctype, node.value[:type]]
    end

    def compile_tag(node)
      @tag_compiler.compile(node) { |n| compile_children(n) }
    end

    def compile_plain(node)
      [:static, node.value[:text]]
    end

    def insert_whitespace?(node)
      case node.type
      when :plain, :tag
        true
      else
        false
      end
    end
  end
end
