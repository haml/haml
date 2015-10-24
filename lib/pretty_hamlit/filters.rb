require 'hamlit/filters'
require 'pretty_hamlit/filters/plain'

module PrettyHamlit
  class Filters
    @registered = Hamlit::Filters.registered.dup

    class << self
      attr_reader :registered

      private

      def register(name, compiler)
        registered[name] = compiler
      end
    end

    register :plain, Plain

    def initialize(options = {})
      @options = options
    end

    def compile(node, indent_level)
      content = find_compiler(node.value[:name]).compile(node)
      [:multi,
       [:code, "#{@options[:buffer]} << ::PrettyHamlit::DynamicIndentation.indent_with(#{indent_level}) do |#{@options[:buffer]}|"],
       content,
       [:code, 'end'],
      ]
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
