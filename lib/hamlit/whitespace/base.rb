module Hamlit
  module Whitespace
    class Base
      private

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
