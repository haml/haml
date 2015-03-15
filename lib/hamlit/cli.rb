require 'hamlit'
require 'thor'

module Hamlit
  class CLI < Thor
    desc 'render HAML', 'Render haml template'
    def render(file)
      code = generate_code(file)
      puts eval(code)
    end

    desc 'compile HAML', 'Show generated rendering code'
    def compile(file)
      code = generate_code(file)
      puts code
    end

    desc 'temple HAML', 'Show a compile result of hamlit AST'
    def temple(file)
      pp generate_temple_ast(file)
    end

    desc 'parse HAML', 'Show parse result'
    def parse(file)
      pp generate_hamlit_ast(file)
    end

    private

    # Flexible default_task, compatible with haml's CLI
    def method_missing(*args)
      return super(*args) if args.length > 1

      render(args.first.to_s)
    end

    def generate_code(file)
      template = File.read(file)
      Hamlit::Engine.new.call(template)
    end

    def generate_temple_ast(file)
      chain = Hamlit::Engine.chain.map(&:first).map(&:to_s)
      compilers = chain.select do |compiler|
        compiler =~ /\AHamlit::/
      end

      template = File.read(file)
      compilers.inject(template) do |exp, compiler|
        Module.const_get(compiler).new.call(exp)
      end
    end

    def generate_hamlit_ast(file)
      template = File.read(file)
      Hamlit::Parser.new.call(template)
    end

    # Enable colored pretty printing only for development environment.
    # I don't think it is a good idea to add pry as runtime dependency
    # just for debug color printing.
    def pp(arg)
      begin
        require 'pry'
        Pry::ColorPrinter.pp(arg)
      rescue LoadError
        require 'pp'
        super(arg)
      end
    end
  end
end
