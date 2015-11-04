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
            compile_on_runtime!(temple, node)
          when !node.value[:attributes].empty?
            compile_static_attributes!(temple, node)
          end
        end
      end

      private

      def compile_on_runtime!(temple, node)
        attrs = node.value[:attributes_hashes]
        attrs.unshift(node.value[:attributes].inspect) if node.value[:attributes] != {}
        temple << [:dynamic, "::Hamlit::AttributeBuilder.build(#{@quote}, #{@format.inspect}, #{attrs.join(', ')})"]
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
