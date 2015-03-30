require 'hamlit/concerns/attribute_builder'
require 'temple/utils'

# Hamlit::Attribute is a module to compile old-style attributes which
# can be compiled only on runtime. If you write old-style attributes
# which is not valid as Ruby hash, the attributes are compiled on runtime.
#
# Note that you should avoid writing such a template for performance.
module Hamlit
  class Attribute
    include Concerns::AttributeBuilder

    def self.build(quote, attributes)
      builder = self.new(quote)
      builder.build(attributes)
    end

    def initialize(quote)
      @quote = quote
    end

    def build(attributes)
      result = ''
      flatten_attributes(attributes).each do |key, value|
        escaped = Temple::Utils.escape_html(value)
        result += " #{key}=#{@quote}#{escaped}#{@quote}"
      end
      result
    end
  end
end
