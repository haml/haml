require 'haml/util'
require 'hamlit/compiler/attribute_compiler'

module Hamlit
  class Compiler
    class TagCompiler
      def initialize(options = {})
        @autoclose = options[:autoclose]
        @attribute_compiler = AttributeCompiler.new(options)
      end

      def compile(node, &block)
        attrs    = @attribute_compiler.compile(node)
        contents = compile_contents(node, &block)
        [:html, :tag, node.value[:name], attrs, contents]
      end

      private

      def compile_contents(node, &block)
        case
        when !node.children.empty?
          yield(node)
        when node.value[:value].nil? && self_closing?(node)
          nil
        when node.value[:parse]
          [:escape, node.value[:escape_html], [:dynamic, node.value[:value]]]
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
