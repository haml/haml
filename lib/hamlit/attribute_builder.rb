require 'temple/utils'

module Hamlit
  class AttributeBuilder
    BOOLEAN_ATTRIBUTES = %w[disabled readonly multiple checked autobuffer
                         autoplay controls loop selected hidden scoped async
                         defer reversed ismap seamless muted required
                         autofocus novalidate formnovalidate open pubdate
                         itemscope allowfullscreen default inert sortable
                         truespeed typemustmatch data].freeze

    def self.build(quote, format, *args)
      builder = self.new(quote, format)
      builder.build(*args)
    end

    def self.build_class(*args)
      classes = []
      args.each do |arg|
        if arg.is_a?(String)
          classes += arg.split(' ')
        elsif arg.is_a?(Array)
          classes += arg.select { |a| a }
        elsif arg
          classes << arg.to_s
        end
      end
      classes.sort.uniq.join(' ')
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

      attributes.sort_by(&:first).each do |key, value|
        if value == true
          case @format
          when :xhtml
            result += " #{key}='#{key}'"
          else
            result += " #{key}"
          end
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
        next if value == attributes

        case value
        when Hash
          flatten_attributes(value).each do |k, v|
            k = k.to_s.gsub(/_/, '-')
            flattened["#{key}-#{k}"] = v if v
          end
        else
          if value || !BOOLEAN_ATTRIBUTES.include?(key)
            flattened[key.to_s] = value
          end
        end
      end
      flattened
    end
  end
end
