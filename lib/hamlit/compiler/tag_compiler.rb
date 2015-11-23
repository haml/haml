require 'hamlit/parser/haml_util'
require 'hamlit/compiler/attribute_compiler'
require 'hamlit/string_interpolation'

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
          return compile_string(node) if RubyExpression.string_literal?(node.value[:value])

          var = @unique_identifier.generate
          [:multi,
           [:code, "#{var} = (#{node.value[:value]}"],
           [:newline],
           [:code, ')'.freeze],
           [:escape, node.value[:escape_html], [:dynamic, var]]
          ]
        else
          [:static, node.value[:value]]
        end
      end

      def compile_string(node)
        temple = [:multi]
        StringInterpolation.compile(node.value[:value]).each do |type, value|
          case type
          when :static
            value = Temple::Utils.escape_html(value) if node.value[:escape_html]
            temple << [:static, value]
          when :dynamic
            if Hamlit::StaticAnalyzer.static?(value)
              value = eval(value).to_s
              value = Temple::Utils.escape_html(value) if node.value[:escape_html] || node.value[:escape_interpolation]
              temple << [:static, value]
            else
              temple << [:escape, node.value[:escape_html] || node.value[:escape_interpolation], [:dynamic, value]]
            end
          end
        end
        temple << [:newline]
      end

      def self_closing?(node)
        return true if @autoclose.include?(node.value[:name])
        node.value[:self_closing]
      end
    end
  end
end
