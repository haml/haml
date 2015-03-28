require 'hamlit/concerns/included'
require 'hamlit/concerns/registerable'

module Hamlit
  module Compilers
    module Filter
      extend Concerns::Included

      included do
        extend Concerns::Registerable
      end

      def on_haml_filter(name, exp)
        ast = compile_filter(name, exp)
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
