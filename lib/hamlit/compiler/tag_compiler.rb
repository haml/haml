require 'hamlit/parser/haml_util'
require 'hamlit/compiler/attribute_compiler'

module Hamlit
  class Compiler
    class TagCompiler
      def initialize(unique_identifier, options)
        @autoclose = options[:autoclose]
        @unique_identifier  = unique_identifier
        @attribute_compiler = AttributeCompiler.new(unique_identifier, options)
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
          var = @unique_identifier.generate
          [:multi,
           [:code, "#{var} = (#{node.value[:value]}"],
           [:newline],
           [:code, ')'.freeze],
           [:escape, node.value[:escape_html], [:dynamic, var]]
          ]
        when ::Hamlit::HamlUtil.contains_interpolation?(node.value[:value])
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
