require 'hamlit/attribute_builder'
require 'hamlit/hash_parser'

module Hamlit
  class Compiler
    class AttributeCompiler
      def initialize(options = {})
        @quote  = options[:attr_quote].inspect.freeze
        @format = options[:format]
        @escape_attrs = options[:escape_attrs]
      end

      def compile(node)
        [:html, :attrs].tap do |temple|
          case
          when !node.value[:attributes_hashes].empty?
            # compile_dynamic_attributes!(temple, node)
            compile_on_runtime!(temple, node)
          when !node.value[:attributes].empty?
            compile_static_attributes!(temple, node)
          end
        end
      end

      private

      def compile_dynamic_attributes!(temple, node)
        hashes = []
        node.value[:attributes_hashes].each do |hash_str|
          hash = HashParser.parse(hash_str)
          return compile_on_runtime!(temple, node) unless hash
          hashes << hash
        end
        hashes.unshift(node.value[:attributes]) if node.value[:attributes] != {}
        compile_statically!(temple, hashes)
      end

      def compile_on_runtime!(temple, node)
        attrs = node.value[:attributes_hashes]
        attrs.unshift(node.value[:attributes].inspect) if node.value[:attributes] != {}
        temple << [:dynamic, "::Hamlit::AttributeBuilder.build(#{@quote}, #{@format.inspect}, #{attrs.join(', ')})"]
      end

      def compile_statically!(temple, hashes)
        hashes.each do |hash|
          hash.each do |key, value|
            temple << [:html, :attr, key, [:escape, @escape_attrs, [:dynamic, value]]]
          end
        end
      end

      def compile_static_attributes!(temple, node)
        node.value[:attributes].sort_by(&:first).each do |name, value|
          case
          when value == true
            temple << [:html, :attr, name, [:multi]]
          when @escape_attrs
            temple << [:html, :attr, name, [:escape, true, [:static, value]]]
          else
            temple << [:html, :attr, name, [:static, value]]
          end
        end
      end
    end
  end
end
