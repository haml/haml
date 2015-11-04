require 'hamlit/attribute_builder'
require 'hamlit/hash_parser'

module Hamlit
  class Compiler
    class AttributeCompiler
      def initialize(options = {})
        @quote  = options[:attr_quote]
        @format = options[:format]
        @escape_attrs = options[:escape_attrs]
      end

      def compile(node)
        hashes = []
        node.value[:attributes_hashes].each do |attribute_str|
          hash = HashParser.parse(attribute_str)
          return runtime_compile(node) unless hash
          hashes << hash
        end
        static_compile(node.value[:attributes], hashes)
      end

      private

      def runtime_compile(node)
        attrs = node.value[:attributes_hashes]
        attrs.unshift(node.value[:attributes].inspect) if node.value[:attributes] != {}
        [:html,
         :attrs,
         [:dynamic,
          '::Hamlit::AttributeBuilder.build' \
          "(#{@quote.inspect}, #{@format.inspect}, #{attrs.join(', ')})",
         ],
        ]
      end

      def static_compile(static_hash, dynamic_hashes)
        temple = [:html, :attrs]
        keys = [*static_hash.keys, *dynamic_hashes.map(&:keys).flatten].uniq.sort
        keys.each do |key|
          case key
          when 'id'.freeze
            compile_id!(temple, key, static_hash, dynamic_hashes)
          when 'class'.freeze
            compile_class!(temple, key, static_hash, dynamic_hashes)
          when 'data'.freeze
            compile_data!(temple, key, static_hash, dynamic_hashes)
          when *AttributeBuilder::BOOLEAN_ATTRIBUTES
            compile_boolean!(temple, key, static_hash, dynamic_hashes)
          else
            compile_common!(temple, key, static_hash, dynamic_hashes)
          end
        end
        temple
      end

      def compile_id!(temple, key, static_hash, dynamic_hashes)
        temple << build_attr(:static, key, static_hash[key]) if static_hash[key]
        dynamic_hashes.each do |dynamic_hash|
          temple << build_attr(:dynamic, key, dynamic_hash[key]) if dynamic_hash[key]
        end
      end

      def compile_class!(temple, key, static_hash, dynamic_hashes)
        temple << build_attr(:static, key, static_hash[key]) if static_hash[key]
        dynamic_hashes.each do |dynamic_hash|
          temple << build_attr(:dynamic, key, dynamic_hash[key]) if dynamic_hash[key]
        end
      end

      def compile_data!(temple, key, static_hash, dynamic_hashes)
        temple << build_attr(:static, key, static_hash[key]) if static_hash[key]
        dynamic_hashes.each do |dynamic_hash|
          temple << build_attr(:dynamic, key, dynamic_hash[key]) if dynamic_hash[key]
        end
      end

      def compile_boolean!(temple, key, static_hash, dynamic_hashes)
        value = build_attr(:static, key, static_hash[key]) if static_hash[key]
        dynamic_hashes.each do |dynamic_hash|
          value = build_attr(:dynamic, key, dynamic_hash[key]) if dynamic_hash[key]
        end
        temple << value
      end

      def compile_common!(temple, key, static_hash, dynamic_hashes)
        value = build_attr(:static, key, static_hash[key]) if static_hash[key]
        dynamic_hashes.each do |dynamic_hash|
          value = build_attr(:dynamic, key, dynamic_hash[key]) if dynamic_hash[key]
        end
        temple << value
      end

      def build_attr(type, key, value)
        [:html, :attr, key, [:escape, @escape_attrs, [type, value]]]
      end
    end
  end
end
