require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Preserve < Base
      def compile(lines)
        [:multi, [:haml, :text, lines.join('&#x000A;')]]
      end
    end
  end
end
