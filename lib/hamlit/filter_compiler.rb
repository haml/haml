require 'hamlit/filter_compiler/plain'

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

    register :plain, Plain

    def compile(node)
      find_compiler(node.value[:name]).compile(node)
    end

    private

    def find_compiler(name)
      compiler = FilterCompiler.registered[name.to_sym]
      raise "FilterCompiler for '#{name}' was not found" unless compiler

      compiler
    end
  end
end
