require 'haml/attribute_parser'

module Haml
  class AttributeCompiler
    # @param type [Symbol] :static or :dynamic
    # @param key [String]
    # @param value [String] Actual string value for :static type, value's Ruby literal for :dynamic type.
    class AttributeValue < Struct.new(:type, :key, :value)
      # @return [String] A Ruby literal of value.
      def to_literal
        case type
        when :static
          Haml::Util.inspect_obj(value)
        when :dynamic
          value
        end
      end

      # Key's substring before a hyphen. This is necessary because values with the same
      # base_key can conflict by Haml::AttributeBuidler#build_data_keys.
      def base_key
        key.split('-', 2).first
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
      attribute_values   = build_attribute_values(attributes, parsed_hashes)
      values_by_base_key = attribute_values.group_by(&:base_key)

      [:multi, *values_by_base_key.keys.sort.map { |base_key|
        compile_attribute_values(values_by_base_key[base_key])
      }]
    end

    private

    # Returns array of AttributeValue instnces from static attributes and dynamic attributes_hashes. For each key,
    # the values' order in returned value is preserved in the same order as Haml::Buffer#attributes's merge order.
    #
    # @param attributes [{ String => String }]
    # @param parsed_hashes [{ String => String }]
    # @return [Array<AttributeValue>]
    def build_attribute_values(attributes, parsed_hashes)
      [].tap do |attribute_values|
        attributes.each do |key, static_value|
          attribute_values << AttributeValue.new(:static, key, static_value)
        end
        parsed_hashes.each do |parsed_hash|
          parsed_hash.each do |key, dynamic_value|
            attribute_values << AttributeValue.new(:dynamic, key, dynamic_value)
          end
        end
      end
    end

    # Compiles attribute values with the same base_key to Temple expression.
    #
    # @param base_values [Array<AttributeValue>] `base_key`'s results are the same. `key`'s result may differ.
    # @return [Array] Temple expression
    def compile_attribute_values(base_values)
      if base_values.map(&:key).uniq.size == 1
        return compile_attribute(base_values.first.key, base_values)
      end

      hash_content = base_values.group_by(&:key).map do |key, values|
        "#{frozen_string(key)} => #{merged_value(key, values)}"
      end.join(', ')
      [:dynamic, "_hamlout.attributes({ #{hash_content} }, nil)"]
    end

    # @param key [String]
    # @param values [Array<AttributeValue>]
    # @return [String]
    def merged_value(key, values)
      "::Haml::AttributeBuilder.merge_values(#{frozen_string(key)}, #{values.map(&:to_literal).join(', ')})"
    end

    # @param str [String]
    # @return [String]
    def frozen_string(str)
      "#{Haml::Util.inspect_obj(str)}.freeze"
    end

    # Compiles attribute values for one key to Temple expression that generates ` key='value'`.
    #
    # @param key [String]
    # @param values [Array<AttributeValue>]
    # @return [Array] Temple expression
    def compile_attribute(key, values)
      [:dynamic, "_hamlout.attributes({ #{frozen_string(key)} => #{merged_value(key, values)} }, nil)"]
    end
  end
end
