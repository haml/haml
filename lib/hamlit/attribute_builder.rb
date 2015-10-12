require 'temple/utils'

module Hamlit
  class AttributeBuilder
    def self.build(quote, format, *args)
      builder = self.new(quote, format)
      builder.build(*args)
    end

    def initialize(quote, format)
      @quote  = quote
      @format = format
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
      when 'id'
        value = value.join('_')
      when 'class'
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
      when 'id'
        values.join('_')
      when 'class'
        values.map(&:to_s).sort.uniq.join(' ')
      end
    end

    def flatten_attributes(attributes)
      flattened = {}

      attributes.each do |key, value|
        case value
        when Hash
          flatten_attributes(value).each do |k, v|
            k = k.to_s.gsub(/_/, '-')
            flattened["#{key}-#{k}"] = v if v
          end
        else
          flattened[key.to_s] = value if value
        end
      end
      flattened
    end
  end
end
