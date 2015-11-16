require 'temple/utils'

module Hamlit::AttributeBuilder
  extend Temple::Utils

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
    def build(escape_attrs, quote, format, *hashes)
      buf    = []
      hashes = hashes.map { |h| stringify_keys(h) }

      keys = hashes.map(&:keys).flatten.sort.uniq
      keys.each do |key|
        values = hashes.map { |h| h[key] }.compact
        case key
        when 'id'.freeze
          build_id!(escape_attrs, quote, buf, values)
        when 'class'.freeze
          build_class!(escape_attrs, quote, buf, values)
        when 'data'.freeze
          buf << build_data(*values)
        when *BOOLEAN_ATTRIBUTES, *DATA_BOOLEAN_ATTRIBUTES
          build_boolean!(escape_attrs, quote, format, buf, key, values)
        else
          build_common!(escape_attrs, quote, buf, key, values)
        end
      end
      buf.join
    end

    def build_id(*values)
      escape_html(values.flatten.select { |v| v }.join('_'))
    end

    def build_class(*values)
      classes = []
      values.each do |value|
        case
        when value.is_a?(String)
          classes += value.split(' ')
        when value.is_a?(Array)
          classes += value.select { |a| a }
        when value
          classes << value.to_s
        end
      end
      escape_html(classes.sort.uniq.join(' '))
    end

    def build_data(*hashes)
      attrs = []
      hash = flat_hyphenate(*hashes)

      hash.sort_by(&:first).each do |key, value|
        case key
        when nil
          attrs << " data='".freeze
          attrs << escape_html(value.to_s)
          attrs << "'".freeze
        when *BOOLEAN_ATTRIBUTES
          if value
            attrs << ' data-'.freeze
            attrs << key
          end
        else
          attrs << ' data-'.freeze
          attrs << key
          attrs << "='".freeze
          attrs << escape_html(value.to_s)
          attrs << "'".freeze
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
          when Hash
            key = '' if key.nil?
            flat_hyphenate(value).each do |k, v|
              result[key << '-'.freeze << k] = v
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

    def build_id!(escape_attrs, quote, buf, values)
      buf << ' id='.freeze
      buf << quote
      if escape_attrs
        buf << escape_html(build_id(*values))
      else
        buf << build_id(*values)
      end
      buf << quote
    end

    def build_class!(escape_attrs, quote, buf, values)
      buf << ' class='.freeze
      buf << quote
      if escape_attrs
        buf << escape_html(build_class(*values))
      else
        buf << build_class(*values)
      end
      buf << quote
    end

    def build_boolean!(escape_attrs, quote, format, buf, key, values)
      value = values.last
      if value
        buf << ' '.freeze
        buf << key
      end
    end

    def build_common!(escape_attrs, quote, buf, key, values)
      buf << ' '.freeze
      buf << key
      buf << '='.freeze
      buf << quote
      if escape_attrs
        buf << escape_html(values.first)
      else
        buf << values.first
      end
      buf << quote
    end
  end
end
