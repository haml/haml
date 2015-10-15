require 'hamlit/compiler/comment_compiler'
require 'hamlit/compiler/doctype_compiler'
require 'hamlit/compiler/tag_compiler'
require 'hamlit/filters'
require 'hamlit/whitespace/compiler'

module Hamlit
  class Compiler
    def initialize(options = {})
      @comment_compiler    = CommentCompiler.new
      @doctype_compiler    = DoctypeCompiler.new(options)
      @tag_compiler        = TagCompiler.new(options)
      @filter_compiler     = Filters.new(options)
      @whitespace_compiler = Whitespace::Compiler.new
    end

    def call(ast)
      compile(ast)
    end

    private

    def compile(node)
      case node.type
      when :root
        compile_children(node)
      when :comment
        compile_comment(node)
      when :doctype
        compile_doctype(node)
      when :filter
        compile_filter(node)
      when :plain
        compile_plain(node)
      when :script
        compile_script(node)
      when :tag
        compile_tag(node)
      when :haml_comment
        [:multi]
      else
        raise InternalError.new("Unexpected node type: #{node.type}")
      end
    end

    def compile_children(node)
      @whitespace_compiler.compile_children(node) { |n| compile(n) }
    end

    def compile_comment(node)
      @comment_compiler.compile(node) { |n| compile_children(n) }
    end

    def compile_doctype(node)
      @doctype_compiler.compile(node)
    end

    def compile_filter(node)
      @filter_compiler.compile(node)
    end

    def compile_plain(node)
      [:static, node.value[:text]]
    end

    def compile_script(node)
      if node.value[:preserve]
        [:dynamic, %Q[Haml::Helpers.find_and_preserve(#{node.value[:text]}, %w(textarea pre code))]]
      elsif node.value[:escape_html]
        [:escape, true, [:dynamic, node.value[:text]]]
      else
        [:dynamic, node.value[:text]]
      end
    end

    def compile_tag(node)
      @tag_compiler.compile(node) { |n| compile_children(n) }
    end

    class InternalError < RuntimeError
    end
  end
end
