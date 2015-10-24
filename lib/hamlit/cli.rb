require 'hamlit'
require 'thor'

module Hamlit
  class CLI < Thor
    class_option :style, type: :string, aliases: ['-t'], default: 'ugly'

    desc 'render HAML', 'Render haml template'
    def render(file)
      code = generate_code(file)
      puts eval(code)
    end

    desc 'compile HAML', 'Show compile result'
    def compile(file)
      print_code generate_code(file)
    end

    desc 'parse HAML', 'Show parse result'
    def parse(file)
      pp generate_ast(file)
    end

    private

    def generate_code(file)
      template = File.read(file)
      Hamlit::HamlEngine.new(template, haml_options).precompiled
    end

    def generate_ast(file)
      template = File.read(file)
      Hamlit::Parser.new.call(template)
    end

    def haml_options
      { ugly: options['style'] == 'ugly' }
    end

    # Flexible default_task, compatible with haml's CLI
    def method_missing(*args)
      return super(*args) if args.length > 1
      render(args.first.to_s)
    end

    def print_code(code)
      require 'pry'
      puts Pry.Code(code).highlighted
    rescue LoadError
      puts code
    end

    # Enable colored pretty printing only for development environment.
    def pp(arg)
      require 'pry'
      Pry::ColorPrinter.pp(arg)
    rescue LoadError
      require 'pp'
      super(arg)
    end
  end
end
