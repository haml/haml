module Hamlit
  class Compiler
    class ChildrenCompiler
      def compile(node, &block)
        temple = [:multi]
        return temple if node.children.empty?

        temple << :whitespace if prepend_whitespace?(node)
        node.children.each do |n|
          rstrip_whitespace!(temple) if nuke_outer_whitespace?(n)
          temple << yield(n)
          temple << :whitespace if insert_whitespace?(n)
        end
        rstrip_whitespace!(temple) if nuke_inner_whitespace?(node)
        confirm_whitespace(temple)
      end

      private

      def confirm_whitespace(temple)
        temple.map do |exp|
          case exp
          when :whitespace
            [:static, "\n"]
          else
            exp
          end
        end
      end

      def prepend_whitespace?(node)
        return false unless %i[comment tag].include?(node.type)
        !nuke_inner_whitespace?(node)
      end

      def nuke_inner_whitespace?(node)
        return false if node.type != :tag
        node.value[:nuke_inner_whitespace]
      end

      def nuke_outer_whitespace?(node)
        return false if node.type != :tag
        node.value[:nuke_outer_whitespace]
      end

      def rstrip_whitespace!(temple)
        if temple[-1] == :whitespace
          temple.delete_at(-1)
        end
      end

      def insert_whitespace?(node)
        return false if nuke_outer_whitespace?(node)

        case node.type
        when :doctype
          node.value[:type] != 'xml'
        when :comment, :filter, :plain, :script, :tag
          true
        else
          false
        end
      end
    end
  end
end
