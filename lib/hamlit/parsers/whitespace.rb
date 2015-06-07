require 'set'

# Hamlit::Parsers::Whitespace cares about "whitespace removal",
# which is achieved by '<' or '>' after html tag.
# NOTE: Whitespace means [:static, "\n"] because it is rendered
# as whitespace on browsers.
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

      def remove_last_outer_space!(exps)
        exps.reverse!
        remove_first_outer_space!(exps)
      ensure
        exps.reverse!
        exps
      end

      private

      # `<` removes spaces inside script or silent script recursively.
      def remove_first_outer_space!(exps)
        deleted = false

        exps.delete_if do |exp|
          name, *args = exp
          case name
          when :static
            break if args != ["\n"]
            deleted = true
            next true
          when :code
            next false
          when :newline
            next false
          when :haml
            # recursive call for script
            remove_last_outer_space!(exp) if args.first == :script
          when :multi
            break if exp == :multi
            # to flatten multi
            remove_last_outer_space!(exp)
          end
          break
        end

        # recursive call for silent script
        remove_last_outer_space!(exps) if deleted
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
