require 'hamlit/compiler'
require 'hamlit/whitespace/indented_compiler'

module Hamlit
  class PrettyCompiler < Compiler
    def initialize(*)
      super
      @tag_indent = 0
      @whitespace_compiler = Whitespace::IndentedCompiler.new
    end

    private

    def compile_children(node)
      @whitespace_compiler.compile_children(node, @tag_indent) { |n| compile(n) }
    end

    def compile_tag(node)
      @tag_indent += 1
      super
    ensure
      @tag_indent -= 1
    end
  end
end
