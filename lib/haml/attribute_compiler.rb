require 'haml/attribute_parser'

module Haml
  class AttributeCompiler
    # @param type [Symbol] :static or :dynamic
    # @param value [String] Actual string value for :static type, value's Ruby literal for :dynamic type.
    class AttributeValue < Struct.new(:type, :value)
      # @return [String] A Ruby literal of value.
      def to_literal
        case type
        when :static
          Haml::Util.inspect_obj(value)
        when :dynamic
          value
        end
      end
    end

    # Returns a script to render attributes on runtime.
    #
    # @param attributes [Hash]
    # @param object_ref [String,:nil]
    # @param attributes_hashes [Array<String>]
    # @return [String] Attributes rendering code
    def self.runtime_build(attributes, object_ref, attributes_hashes)
      "_hamlout.attributes(#{Haml::Util.inspect_obj(attributes)}, #{object_ref},#{attributes_hashes.join(', ')})"
    end

    # Returns Temple expression to render attributes.
    #
    # @param attributes [Hash]
    # @param object_ref [String,:nil]
    # @param attributes_hashes [Array<String>]
    # @return [Array] Temple expression
    def compile(attributes, object_ref, attributes_hashes)
      if object_ref != :nil || !AttributeParser.available?
        return [:dynamic, AttributeCompiler.runtime_build(attributes, object_ref, attributes_hashes)]
      end

      parsed_hashes = attributes_hashes.map do |attribute_hash|
        unless (hash = AttributeParser.parse(attribute_hash))
          return [:dynamic, AttributeCompiler.runtime_build(attributes, object_ref, attributes_hashes)]
        end
        hash
      end

      values_by_key = build_attribute_values_by_key(attributes, parsed_hashes)
      sorted_keys   = values_by_key.keys.sort
      [:multi, *sorted_keys.map { |k| compile_attribute(k, values_by_key[k]) }]
    end

    private

    # Builds { key => attribute values } hash from static attributes and dynamic attributes_hashes.
    # The order of attribute values are the same as Haml::Buffer#attributes's merge order.
    #
    # @param attributes [{ String => String }]
    # @param parsed_hashes [{ String => String }]
    # @return [{ String => Array<AttributeValue> }]
    def build_attribute_values_by_key(attributes, parsed_hashes)
      Hash.new { |h, k| h[k] = [] }.tap do |values_by_key|
        attributes.each do |attr, static_value|
          values_by_key[attr] << AttributeValue.new(:static, static_value)
        end
        parsed_hashes.each do |parsed_hash|
          parsed_hash.each do |attr, dynamic_value|
            values_by_key[attr] << AttributeValue.new(:dynamic, dynamic_value)
          end
        end
      end
    end

    # Compiles one attribute to Temple expression for rendering " key='value'".
    #
    # @param key [String]
    # @param values [Array<AttributeValue>]
    # @return [Array] Temple expression
    def compile_attribute(key, values)
      code = "_hamlout.attributes({ #{Haml::Util.inspect_obj(key)}.freeze => "\
        "::Haml::AttributeBuilder.merge_values(#{Haml::Util.inspect_obj(key)}.freeze, #{values.map(&:to_literal).join(', ')}) }, nil)"
      [:dynamic, code]
    end
  end
end
