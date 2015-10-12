require 'hamlit/filter_compiler/base'
require 'hamlit/filter_compiler/css'
require 'hamlit/filter_compiler/escaped'
require 'hamlit/filter_compiler/javascript'
require 'hamlit/filter_compiler/plain'
require 'hamlit/filter_compiler/preserve'

module Hamlit
  class FilterCompiler
    @registered = {}

    class << self
      attr_reader :registered

      private

      def register(name, compiler)
        registered[name] = compiler
      end
    end

    register :css,        Css
    register :escaped,    Escaped
    register :javascript, Javascript
    register :plain,      Plain
    register :preserve,   Preserve

    def initialize(options = {})
      @format = options[:format]
    end

    def compile(node)
      find_compiler(node.value[:name]).compile(node)
    end

    private

    def find_compiler(name)
      name = name.to_sym
      compiler = FilterCompiler.registered[name]
      raise NotFound.new("FilterCompiler for '#{name}' was not found") unless compiler

      compilers[name] ||= compiler.new(@format)
    end

    def compilers
      @compilers ||= {}
    end

    class NotFound < RuntimeError
    end
  end
end
