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

    def self.build(quote, *args)
      builder = self.new(quote)
      builder.build(*args)
    end

    def initialize(quote)
      @quote = quote
    end

    def build(*args)
      result = ''
      attributes = args.inject({}) do |attrs, arg|
        merge_attributes(attrs, arg)
      end

      attributes.each do |key, value|
        if value == true
          result += " #{key}"
          next
        end

        value = refine_joinable_value(key, value) if value.is_a?(Array)
        escaped = Temple::Utils.escape_html(value)
        result += " #{key}=#{@quote}#{escaped}#{@quote}"
      end
      result
    end

    private

    def refine_joinable_value(key, value)
      case key
      when :id
        value = value.join('_')
      when :class
        value = value.join(' ')
      else
        value
      end
    end

    def merge_attributes(base, target)
      result = {}
      base   = flatten_attributes(base)
      target = flatten_attributes(target)

      (base.keys | target.keys).each do |key|
        result[key] = merge_attribute_value(base, target, key)
      end
      result
    end

    def merge_attribute_value(base, target, key)
      return target[key] unless base[key]
      return base[key]   unless target[key]

      values = [base[key], target[key]].flatten.compact
      case key
      when :id
        values.join('_')
      when :class
        values.map(&:to_s).sort.uniq.join(' ')
      end
    end
  end
end
