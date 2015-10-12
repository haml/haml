require 'hamlit/filter_compiler/escaped'
require 'hamlit/filter_compiler/plain'
require 'hamlit/filter_compiler/preserve'

module Hamlit
  class FilterCompiler
    @registered = {}

    class << self
      attr_reader :registered

      private

      def register(name, compiler)
        registered[name] = compiler.new
      end
    end

    register :escaped,  Escaped
    register :plain,    Plain
    register :preserve, Preserve

    def compile(node)
      find_compiler(node.value[:name]).compile(node)
    end

    private

    def find_compiler(name)
      compiler = FilterCompiler.registered[name.to_sym]
      raise NotFound.new("FilterCompiler for '#{name}' was not found") unless compiler

      compiler
    end

    class NotFound < RuntimeError
    end
  end
end
