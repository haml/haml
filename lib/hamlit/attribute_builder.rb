require 'hamlit/object_ref'
require 'temple/utils'

module Hamlit::AttributeBuilder
  BOOLEAN_ATTRIBUTES = %w[disabled readonly multiple checked autobuffer
                       autoplay controls loop selected hidden scoped async
                       defer reversed ismap seamless muted required
                       autofocus novalidate formnovalidate open pubdate
                       itemscope allowfullscreen default inert sortable
                       truespeed typemustmatch data].freeze
  DATA_BOOLEAN_ATTRIBUTES = BOOLEAN_ATTRIBUTES.map { |a| "data-#{a}" }.freeze

  # NOTE: Since this module is used on runtime, its methods are designed to be
  # class methods which takes all options as arguments for performance.
  class << self
    def build(escape_attrs, quote, format, object_ref, *hashes)
      buf    = []
      hashes = hashes.map { |h| stringify_keys(h) }
      hashes << Hamlit::ObjectRef.parse(object_ref) if object_ref

      keys = hashes.map(&:keys).flatten.sort.uniq
      keys.each do |key|
        values = hashes.map { |h| h[key] }.compact
        case key
        when 'id'.freeze
          buf << " id=#{quote}#{build_id(escape_attrs, *values)}#{quote}"
        when 'class'.freeze
          buf << " class=#{quote}#{build_class(escape_attrs, *values)}#{quote}"
        when 'data'.freeze
          buf << build_data(escape_attrs, quote, *values)
        when *BOOLEAN_ATTRIBUTES, *DATA_BOOLEAN_ATTRIBUTES
          build_boolean!(escape_attrs, quote, format, buf, key, values)
        else
          buf << " #{key}=#{quote}#{escape_html(escape_attrs, values.first.to_s)}#{quote}"
        end
      end
      buf.join
    end

    def build_id(escape_attrs, *values)
      escape_html(escape_attrs, values.flatten.select { |v| v }.join('_'))
    end

    def build_class(escape_attrs, *values)
      if values.size == 1
        value = values.first
        case
        when value.is_a?(String)
          # noop
        when value.is_a?(Array)
          value = value.select { |v| v }.sort.uniq.join(' ')
        when value
          value = value.to_s
        else
          return ''
        end
        return escape_html(escape_attrs, value)
      end

      classes = []
      values.each do |value|
        case
        when value.is_a?(String)
          classes += value.split(' ')
        when value.is_a?(Array)
          classes += value.select { |v| v }
        when value
          classes << value.to_s
        end
      end
      escape_html(escape_attrs, classes.sort.uniq.join(' '))
    end

    def build_data(escape_attrs, quote, *hashes)
      attrs = []
      hash = flat_hyphenate(*hashes)

      hash.sort_by(&:first).each do |key, value|
        case key
        when nil
          attrs << " data=#{quote}#{escape_html(escape_attrs, value.to_s)}#{quote}"
        when *BOOLEAN_ATTRIBUTES
          attrs << " data-#{key}" if value
        else
          attrs << " data-#{key}=#{quote}#{escape_html(escape_attrs, value.to_s)}#{quote}"
        end
      end
      attrs.join
    end

    private

    def flat_hyphenate(*hashes)
      result = {}
      hashes.each do |hash|
        unless hash.is_a?(Hash)
          result[nil] = hash
          next
        end

        hash.each do |key, value|
          key = key.to_s.tr('_'.freeze, '-'.freeze) unless key.nil?
          case value
          when hash
            # ignore cyclic reference
          when Hash
            key = '' if key.nil?
            flat_hyphenate(value).each do |k, v|
              result["#{key}-#{k}"] = v
            end
          else
            result[key] = value
          end
        end
      end
      result
    end

    def stringify_keys(hash)
      result = {}
      hash.each do |key, value|
        result[key.to_s] = value
      end
      result
    end

    def build_boolean!(escape_attrs, quote, format, buf, key, values)
      value = values.last
      case value
      when true
        case format
        when :xhtml
          buf << " #{key}=#{quote}#{key}#{quote}"
        else
          buf << " #{key}"
        end
      when false, nil
        # omitted
      else
        buf << " #{key}=#{quote}#{escape_html(escape_attrs, value)}#{quote}"
      end
    end

    def escape_html(escape_attrs, str)
      if escape_attrs
        Temple::Utils.escape_html(str)
      else
        str
      end
    end
  end
end
