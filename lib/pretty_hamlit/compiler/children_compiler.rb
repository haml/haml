require 'hamlit/compiler/children_compiler'

module PrettyHamlit
  class Compiler < Hamlit::Compiler
    class ChildrenCompiler < Hamlit::Compiler::ChildrenCompiler
      def compile(node, indent_level, &block)
        temple = [:multi]
        return temple if node.children.empty?

        temple << :whitespace if prepend_whitespace?(node)
        node.children.each do |n|
          rstrip_whitespace!(temple) if nuke_outer_whitespace?(n)
          temple << yield(n)
          if insert_whitespace?(n)
            if nuke_inner_whitespace?(node)
              temple << :weak_whitespace
            else
              temple << :whitespace
            end
          end
        end
        rstrip_whitespace!(temple) if nuke_inner_whitespace?(node)
        weaken_last_whitespace!(temple)
        confirm_whitespace(temple, indent_level)
      end

      private

      def rstrip_whitespace!(temple)
        if %i[whitespace weak_whitespace].include?(temple[-1])
          temple.delete_at(-1)
        end
      end

      def weaken_last_whitespace!(temple)
        if temple[-1] == :whitespace
          temple.delete_at(-1)
          temple << :weak_whitespace
        end
      end

      def confirm_whitespace(temple, indent_level)
        temple.map do |exp|
          case exp
          when :whitespace
            [:static, "\n" + ('  ' * indent_level)]
          when :weak_whitespace
            level = [0, indent_level - 1].max
            [:static, "\n" + ('  ' * level)]
          else
            exp
          end
        end
      end
    end
  end
end
