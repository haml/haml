require 'hamlit/concerns/included'
require 'hamlit/concerns/registerable'
require 'hamlit/filters/escaped'
require 'hamlit/filters/plain'
require 'hamlit/filters/preserve'

module Hamlit
  module Compilers
    module Filter
      extend Concerns::Included

      included do
        extend Concerns::Registerable

        register :escaped,  Filters::Escaped
        register :plain,    Filters::Plain
        register :preserve, Filters::Preserve
      end

      def on_haml_filter(name, lines)
        ast = compile_filter(name, lines)
        compile(ast)
      end

      private

      def compile_filter(name, exp)
        self.class.find(name).compile(exp)
      end
    end
  end
end
