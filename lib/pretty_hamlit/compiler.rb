require 'hamlit/compiler'
require 'pretty_hamlit/filters'
require 'pretty_hamlit/whitespace_compiler'

module PrettyHamlit
  class Compiler < Hamlit::Compiler
    def initialize(options = {})
      super
      @indent_level = 0

      @filter_compiler     = Filters.new(options)
      @whitespace_compiler = WhitespaceCompiler.new
    end

    private

    def compile_children(node)
      @whitespace_compiler.compile_children(node, @indent_level) { |n| compile(n) }
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
      super
    ensure
      @indent_level -= 1
    end
  end
end
