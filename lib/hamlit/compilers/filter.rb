require 'hamlit/concerns/included'
require 'hamlit/concerns/registerable'
require 'hamlit/filters/plain'

module Hamlit
  module Compilers
    module Filter
      extend Concerns::Included

      included do
        extend Concerns::Registerable

        register :plain, Filters::Plain
      end

      def on_haml_filter(name, lines)
        ast = compile_filter(name, lines)
        compile(ast)
      end

      private

      def compile_filter(name, exp)
        compiler = Compiler.find(name)
        compiler.compile(exp)
      end
    end
  end
end
