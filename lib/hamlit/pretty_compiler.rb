require 'hamlit/compiler'
require 'hamlit/whitespace/indented_compiler'

module Hamlit
  class PrettyCompiler < Compiler
    def initialize(*)
      super
      @indent_level = 0
      @whitespace_compiler = Whitespace::IndentedCompiler.new
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

    def compile_tag(node)
      @indent_level += 1
      super
    ensure
      @indent_level -= 1
    end
  end
end
