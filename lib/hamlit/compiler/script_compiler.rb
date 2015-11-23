require 'hamlit/ruby_expression'
require 'hamlit/static_analyzer'
require 'hamlit/string_interpolation'

module Hamlit
  class Compiler
    class ScriptCompiler
      def initialize(unique_identifier)
        @unique_identifier = unique_identifier
      end

      def compile(node, &block)
        case
        when node.children.empty? && RubyExpression.string_literal?(node.value[:text])
          StringInterpolation.compile_node(node, :text).push([:newline])
        when node.children.empty? && StaticAnalyzer.static?(node.value[:text])
          static_compile(node)
        else
          dynamic_compile(node, &block)
        end
      end

      private

      def static_compile(node)
        str = eval("(#{node.value[:text]}).to_s")
        if node.value[:escape_html]
          str = Temple::Utils.escape_html(str)
        elsif node.value[:preserve]
          str = ::Hamlit::HamlHelpers.find_and_preserve(str, %w(textarea pre code))
        end
        [:multi, [:static, str], [:newline]]
      end

      def dynamic_compile(node, &block)
        var = @unique_identifier.generate
        temple = compile_script_assign(var, node, &block)
        temple << compile_script_result(var, node)
      end

      def compile_script_assign(var, node, &block)
        if node.children.empty?
          [:multi,
           [:code, "#{var} = (#{node.value[:text]}"],
           [:newline],
           [:code, ')'.freeze],
          ]
        else
          [:multi,
           [:code, "#{var} = #{node.value[:text]}"],
           [:newline],
           yield(node),
           [:code, 'end'.freeze],
          ]
        end
      end

      def compile_script_result(result, node)
        if !node.value[:escape_html] && node.value[:preserve]
          result = find_and_preserve(result)
        else
          result = '(' << result << ').to_s'.freeze
        end
        [:escape, node.value[:escape_html], [:dynamic, result]]
      end

      def find_and_preserve(code)
        %Q[::Hamlit::HamlHelpers.find_and_preserve(#{code}, %w(textarea pre code))]
      end

      def escape_html(temple)
        [:escape, true, temple]
      end
    end
  end
end
