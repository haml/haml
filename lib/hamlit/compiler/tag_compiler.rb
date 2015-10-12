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
        attrs = [:html, :attrs]
        node.value[:attributes_hashes].each do |attribute_hash|
          attrs << [:dynamic, "::Hamlit::AttributeBuilder.build(#{@quote}, #{attribute_hash})"]
        end
        node.value[:attributes].each do |name, value|
          attrs << [:html, :attr, name, [:static, value]]
        end
        attrs
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
