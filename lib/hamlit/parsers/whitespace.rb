require 'set'

# Hamlit::Parsers::Whitespace cares about "whitespace removal",
# which is achieved by '<' or '>' after html tag.
module Hamlit
  module Parsers
    module Whitespace
      def parse_whitespace_removal(scanner)
        if scanner.match?(/</)
          inner_removal = parse_inner_removal(scanner)
          parse_outer_removal(scanner)
        else
          parse_outer_removal(scanner)
          inner_removal = parse_inner_removal(scanner)
        end
        inner_removal
      end

      def remove_last_outer_space!(ast)
        index = find_last_newline_index(ast)
        return unless index

        ast.delete_at(index)
      end

      private

      # Find [:static, "\n"]'s position ignoring [:code].
      # If it is not found, return nil.
      def find_last_newline_index(ast)
        ast.reverse_each.with_index do |node, index|
          sexp, *args = node
          next if sexp == :code
          return if node != [:static, "\n"]

          return ast.length - index - 1
        end
        nil
      end

      def reset_outer_removal
        @outer_removal = Set.new
        @tag_indent    = 0
      end

      def with_tag_nested(&block)
        @tag_indent += 1
        with_indented { block.call }
      ensure
        @outer_removal.delete(@tag_indent)
        @tag_indent -= 1
      end

      def parse_inner_removal(scanner)
        scanner.scan(/</)
      end

      def parse_outer_removal(scanner)
        if scanner.scan(/>/)
          @outer_removal.add(@tag_indent)
        else
          @outer_removal.delete(@tag_indent)
        end
      end

      def outer_remove?
        @outer_removal.include?(@tag_indent)
      end
    end
  end
end
