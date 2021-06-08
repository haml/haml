# frozen_string_literal: true
require 'haml/parser/haml_util'

module Haml
  class Filters
    class Base
      def initialize(options = {})
        @format = options[:format]
      end
    end
  end
end
