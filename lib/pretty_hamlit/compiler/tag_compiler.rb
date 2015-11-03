require 'hamlit/compiler/tag_compiler'

module PrettyHamlit
  class Compiler < Hamlit::Compiler
    class TagCompiler < Hamlit::Compiler::TagCompiler
      def initialize(options = {})
        super
        @buffer = options[:buffer]
      end

      def compile(node, indent_level, &block)
        attrs    = @attribute_compiler.compile(node)
        contents = compile_contents(node, indent_level, &block)
        [:html, :tag, node.value[:name], attrs, contents]
      end

      private

      def compile_contents(node, indent_level, &block)
        case
        when !node.children.empty?
          yield(node)
        when node.value[:value].nil? && self_closing?(node)
          nil
        when node.value[:parse]
          [:multi,
           [:code, "#{@buffer} << ::PrettyHamlit::DynamicIndentation.inline_or_expand(#{indent_level}) do |#{@buffer}|"],
           [:dynamic, node.value[:value]],
           [:code, 'end'],
          ]
        when Haml::Util.contains_interpolation?(node.value[:value])
          [:dynamic, node.value[:value]]
        else
          [:static, node.value[:value]]
        end
      end
    end
  end
end
