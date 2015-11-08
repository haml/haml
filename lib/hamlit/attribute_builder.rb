require 'temple/utils'

module Hamlit
  class AttributeBuilder
    BOOLEAN_ATTRIBUTES = %w[disabled readonly multiple checked autobuffer
                         autoplay controls loop selected hidden scoped async
                         defer reversed ismap seamless muted required
                         autofocus novalidate formnovalidate open pubdate
                         itemscope allowfullscreen default inert sortable
                         truespeed typemustmatch data].freeze

    def self.build(quote, format, *hashes)
      builder = self.new(quote, format)
      builder.build(*hashes)
    end

    def self.build_id(*values)
      values.select { |v| v }.join('_')
    end

    def self.build_class(*values)
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
      classes.sort.uniq.join(' ')
    end

    def initialize(quote, format)
      @quote  = quote
      @format = format
    end

    def build(*hashes)
      buf    = []
      hashes = hashes.map { |h| stringify_keys(h) }

      keys = hashes.map(&:keys).flatten.sort.uniq
      keys.each do |key|
        values = hashes.map { |h| h[key] }.select { |v| v }
        case key
        when 'id'.freeze
          build_id!(buf, values)
        when 'class'.freeze
          build_class!(buf, values)
        when *BOOLEAN_ATTRIBUTES
          build_boolean!(buf, key, values)
        else
          build_common!(buf, key, values)
        end
      end
      buf.join
    end

    private

    def stringify_keys(hash)
      result = {}
      hash.each do |key, value|
        result[key.to_s] = value
      end
      result
    end

    def build_id!(buf, values)
      buf << ' id='.freeze
      buf << @quote
      buf << AttributeBuilder.build_id(*values)
      buf << @quote
    end

    def build_class!(buf, values)
      buf << ' class='.freeze
      buf << @quote
      buf << AttributeBuilder.build_class(*values)
      buf << @quote
    end

    def build_boolean!(buf, key, values)
      value = values.last
      if value
        buf << ' '.freeze
        buf << key
      end
    end

    def build_common!(buf, key, values)
      buf << ' '.freeze
      buf << key
      buf << '='.freeze
      buf << @quote
      buf << values.first.to_s
      buf << @quote
    end
  end
end
