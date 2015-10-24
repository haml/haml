require 'pretty_hamlit/compiler/children_compiler'
require 'pretty_hamlit/compiler/tag_compiler'
require 'pretty_hamlit/filters'

module PrettyHamlit
  class Compiler < Hamlit::Compiler
    def initialize(options = {})
      super
      @indent_level = 0

      @children_compiler = ChildrenCompiler.new
      @tag_compiler      = TagCompiler.new(options)

      @filter_compiler = Filters.new(options)
    end

    private

    def compile_children(node)
      @children_compiler.compile(node, @indent_level) { |n| compile(n) }
    end

    def compile_comment(node)
      @indent_level += 1
      super
    ensure
      @indent_level -= 1
    end

    def compile_filter(node)
      @filter_compiler.compile(node, @indent_level)
    end

    def compile_tag(node)
      @indent_level += 1
      @tag_compiler.compile(node, @indent_level) { |n| compile_children(n) }
    ensure
      @indent_level -= 1
    end
  end
end
