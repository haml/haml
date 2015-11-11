require 'temple/utils'

module Hamlit
  class AttributeBuilder
    BOOLEAN_ATTRIBUTES = %w[disabled readonly multiple checked autobuffer
                         autoplay controls loop selected hidden scoped async
                         defer reversed ismap seamless muted required
                         autofocus novalidate formnovalidate open pubdate
                         itemscope allowfullscreen default inert sortable
                         truespeed typemustmatch data].freeze
    DATA_BOOLEAN_ATTRIBUTES = BOOLEAN_ATTRIBUTES.map { |a| "data-#{a}" }.freeze

    class << self
      def build(options, *hashes)
        builder = self.new(options)
        builder.build(*hashes)
      end

      def build_id(*values)
        values.select { |v| v }.join('_')
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
        classes.sort.uniq.join(' ')
      end

      def build_data(*hashes)
        attrs = []
        hash = flat_hyphenate(*hashes)

        hash.sort_by(&:first).each do |key, value|
          case key
          when *BOOLEAN_ATTRIBUTES
            if value
              attrs << ' data-'.freeze
              attrs << key
            end
          else
            attrs << ' data-'.freeze
            attrs << key
            attrs << "='".freeze
            attrs << Temple::Utils.escape_html(value.to_s)
            attrs << "'".freeze
          end
        end
        attrs.join
      end

      private

      def escape_html(value)
        Temple::Utils.escape_html(value)
      end

      def flat_hyphenate(*hashes)
        result = {}
        hashes.each do |hash|
          hash.each do |key, value|
            key = key.to_s.tr('_'.freeze, '-'.freeze)
            case value
            when hash
            when Hash
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
    end

    def initialize(options)
      @quote  = options[:quote]
      @format = options[:format]
      @escape_attrs = options[:escape_attrs]
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
        when 'data'.freeze
          build_data!(buf, values)
        when *BOOLEAN_ATTRIBUTES, *DATA_BOOLEAN_ATTRIBUTES
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

    def build_data!(buf, values)
      buf << AttributeBuilder.build_data(*values)
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
