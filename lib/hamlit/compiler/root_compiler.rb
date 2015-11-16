require 'hamlit/helpers'
require 'hamlit/rails_helpers'

module Hamlit
  class Compiler
    class RootCompiler
      def initialize(options = {})
        if options[:generator] == Temple::Generators::RailsOutputBuffer
          @rails_mode = true
        end
      end

      def compile(node, &block)
        [:multi,
         [:code, "extend ::#{helper_module.name}"],
         block.call(node),
        ]
      end

      private

      def helper_module
        if @rails_mode
          Hamlit::RailsHelpers
        else
          Hamlit::Helpers
        end
      end
    end
  end
end
