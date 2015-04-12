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

    def self.build(quote, base, attributes = {})
      builder = self.new(quote)
      builder.build(base, attributes)
    end

    def initialize(quote)
      @quote = quote
    end

    def build(base, attributes)
      result = ''
      merge_attributes(base, attributes).each do |key, value|
        if value == true
          result += " #{key}"
          next
        end

        escaped = Temple::Utils.escape_html(value)
        result += " #{key}=#{@quote}#{escaped}#{@quote}"
      end
      result
    end

    private

    def merge_attributes(base, target)
      result = {}
      base   = flatten_attributes(base)
      target = flatten_attributes(target)

      (base.keys | target.keys).each do |key|
        if base[key] && target[key]
          case key
          when :id
            result[key] = [base[key], target[key]].compact.join('_')
          else
            result[key] = [base[key], target[key]].compact.join(' ')
          end
        else
          result[key] = base[key].nil? ? target[key] : base[key]
        end
      end
      result
    end
  end
end
