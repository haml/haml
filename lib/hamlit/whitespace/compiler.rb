require 'hamlit/whitespace/base'

module Hamlit
  module Whitespace
    class Compiler < Base
      def compile_children(node, &block)
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
    end
  end
end
