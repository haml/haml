# frozen_string_literal: true
require 'hamlit'
require 'thor'

module Hamlit
  class CLI < Thor
    class_option :escape_html, type: :boolean, default: true
    class_option :escape_attrs, type: :boolean, default: true

    desc 'render HAML', 'Render haml template'
    option :load_path, type: :string, aliases: %w[-I]
    option :require, type: :string, aliases: %w[-r]
    def render(file)
      process_load_options
      code = generate_code(file)
      puts eval(code)
    end

    desc 'compile HAML', 'Show compile result'
    option :actionview, type: :boolean, default: false, aliases: %w[-a]
    def compile(file)
      print_code generate_code(file)
    end

    desc 'temple HAML', 'Show temple intermediate expression'
    def temple(file)
      pp generate_temple(file)
    end

    desc 'parse HAML', 'Show parse result'
    def parse(file)
      pp generate_ast(file)
    end

    desc 'version', 'Show the used hamlit version'
    def version
      puts Hamlit::VERSION
    end

    private

    def process_load_options
      if options[:load_path]
        options[:load_path].split(':').each do |dir|
          $LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)
        end
      end

      if options[:require]
        require options[:require]
      end
    end

    def generate_code(file)
      template = File.read(file)
      if options[:actionview]
        require 'action_view'
        require 'action_view/base'
        require 'hamlit/rails_template'
        handler = Hamlit::RailsTemplate.new
        template = ActionView::Template.new(template, 'inline template', handler, { locals: [] })
        code = handler.call(template)
        source = <<-end_src
          def _inline_template___2144273726781623612_70327218547300(local_assigns, output_buffer)
            _old_virtual_path, @virtual_path = @virtual_path, nil;_old_output_buffer = @output_buffer;;#{code}
          ensure
            @virtual_path, @output_buffer = _old_virtual_path, _old_output_buffer
          end
        end_src
      else
        Hamlit::Engine.new(engine_options).call(template)
      end
    end

    def generate_ast(file)
      template = File.read(file)
      Hamlit::Parser.new(engine_options).call(template)
    end

    def generate_temple(file)
      ast = generate_ast(file)
      Hamlit::Compiler.new(engine_options).call(ast)
    end

    def engine_options
      Hamlit::Engine.options.to_h.merge(
        escape_attrs: options[:escape_attrs],
        escape_html:  options[:escape_html],
      )
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
