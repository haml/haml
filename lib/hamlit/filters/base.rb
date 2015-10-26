require 'haml/util'

module Hamlit
  class Filters
    class Base
      def initialize(options = {})
        @format = options[:format]
      end
    end
  end
end
