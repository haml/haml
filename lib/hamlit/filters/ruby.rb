require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Ruby < Base
      def compile(lines)
        [:multi, [:code, lines.join("\n")]]
      end
    end
  end
end
