require 'hamlit'
require 'thor'

module Hamlit
  class CLI < Thor
    desc 'render HAML', 'Render haml template'
    def render(file)
      code = generate_code(file)
      puts eval(code)
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
  end
end
