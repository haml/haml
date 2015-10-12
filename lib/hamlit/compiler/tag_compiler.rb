require 'haml/util'

module Hamlit
  class Compiler
    class TagCompiler
      def initialize(options = {})
        @quote     = options[:attr_quote].inspect.freeze
        @format    = options[:format]
        @autoclose = options[:autoclose]
      end

      def compile(node, &block)
        attrs    = compile_attributes(node)
        contents = compile_contents(node, &block)
        [:html, :tag, node.value[:name], attrs, contents]
      end

      private

      def compile_attributes(node)
        [:html, :attrs].tap do |temple|
          case
          when !node.value[:attributes_hashes].empty?
            compile_dynamic_attributes!(temple, node)
          when !node.value[:attributes].empty?
            compile_static_attributes!(temple, node)
          end
        end
      end

      def compile_static_attributes!(temple, node)
        node.value[:attributes].sort_by(&:first).each do |name, value|
          temple << [:html, :attr, name, [:static, value]]
        end
      end

      def compile_dynamic_attributes!(temple, node)
        node.value[:attributes_hashes].each do |attribute_hash|
          temple << [:dynamic, "::Hamlit::AttributeBuilder.build(#{@quote}, #{attribute_hash})"]
        end
      end

      def compile_contents(node, &block)
        case
        when !node.children.empty?
          yield(node)
        when node.value[:value].nil? && self_closing?(node)
          nil
        when Haml::Util.contains_interpolation?(node.value[:value])
          [:dynamic, node.value[:value]]
        else
          [:static, node.value[:value]]
        end
      end

      def self_closing?(node)
        return true if @autoclose.include?(node.value[:name])
        node.value[:self_closing]
      end
    end
  end
end
