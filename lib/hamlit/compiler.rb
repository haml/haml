require 'hamlit/tag_compiler'
require 'hamlit/doctype_compiler'

module Hamlit
  class Compiler
    def initialize(options = {})
      @doctype_compiler = DoctypeCompiler.new(options[:format])
      @tag_compiler     = TagCompiler.new(options[:attr_quote])
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
      @doctype_compiler.compile(node)
    end

    def compile_tag(node)
      @tag_compiler.compile(node) { |n| compile_children(n) }
    end

    def compile_plain(node)
      [:static, node.value[:text]]
    end

    def insert_whitespace?(node)
      case node.type
      when :doctype, :plain, :tag
        true
      else
        false
      end
    end
  end
end
