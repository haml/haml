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

      private

      def reset_outer_removal
        @outer_removal = Set.new
      end

      def parse_inner_removal(scanner)
        scanner.scan(/</)
      end

      def parse_outer_removal(scanner)
        if scanner.scan(/>/)
          @outer_removal.add(@current_indent)
        else
          @outer_removal.delete(@current_indent)
        end
      end
    end
  end
end
