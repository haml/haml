require 'hamlit/helpers'

module Hamlit
  module Filters
    class Preserve
      def compile(lines)
        ast = [:multi]
        ast << [:haml, :text, lines.join('&#x000A;')]
        ast
      end
    end
  end
end
