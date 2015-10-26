require 'hamlit/filters/base'
require 'hamlit/filters/css'
require 'hamlit/filters/escaped'
require 'hamlit/filters/javascript'
require 'hamlit/filters/plain'
require 'hamlit/filters/preserve'
require 'hamlit/filters/ruby'

module Hamlit
  class Filters
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
    register :ruby,       Ruby

    def initialize(options = {})
      @options = options
    end

    def compile(node)
      find_compiler(node.value[:name]).compile(node)
    end

    private

    def find_compiler(name)
      name = name.to_sym
      compiler = Filters.registered[name]
      raise NotFound.new("FilterCompiler for '#{name}' was not found") unless compiler

      compilers[name] ||= compiler.new(@options)
    end

    def compilers
      @compilers ||= {}
    end

    class NotFound < RuntimeError
    end
  end
end
