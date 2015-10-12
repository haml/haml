require 'hamlit/compiler/comment_compiler'
require 'hamlit/compiler/doctype_compiler'
require 'hamlit/compiler/tag_compiler'
require 'hamlit/filters'
require 'hamlit/whitespace_handler'

module Hamlit
  class Compiler
    def initialize(options = {})
      @comment_compiler   = CommentCompiler.new
      @doctype_compiler   = DoctypeCompiler.new(options)
      @tag_compiler       = TagCompiler.new(options)
      @filter_compiler    = Filters.new(options)
      @whitespace_handler = WhitespaceHandler.new
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
      when :tag
        compile_tag(node)
      when :plain
        compile_plain(node)
      else
        [:multi]
      end
    end

    def compile_children(node)
      @whitespace_handler.compile_children(node) { |n| compile(n) }
    end

    def compile_doctype(node)
      @doctype_compiler.compile(node)
    end

    def compile_filter(node)
      @filter_compiler.compile(node)
    end

    def compile_comment(node)
      @comment_compiler.compile(node) { |n| compile_children(n) }
    end

    def compile_tag(node)
      @tag_compiler.compile(node) { |n| compile_children(n) }
    end

    def compile_plain(node)
      [:static, node.value[:text]]
    end
  end
end
