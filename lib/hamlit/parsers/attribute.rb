require 'ripper'
require 'hamlit/concerns/balanceable'

module Hamlit
  module Parsers
    module Attribute
      include Concerns::Balanceable

      def parse_attributes(scanner)
        if scanner.match?(/{/)
          parse_old_attributes(scanner) + parse_new_attributes(scanner)
        else
          parse_new_attributes(scanner) + parse_old_attributes(scanner)
        end
      end

      private

      def parse_old_attributes(scanner)
        [read_braces(scanner)].compact
      end

      def parse_new_attributes(scanner)
        return [] unless scanner.match?(/\(/)

        tokens = Ripper.lex(scanner.rest)
        until balanced_parens_exist?(tokens)
          @current_lineno += 1
          scanner.concat(current_line)
          tokens = Ripper.lex(scanner.rest)
        end

        tokens      = fetch_balanced_parentheses(tokens)
        scanner.pos += tokens.last.first.last + 1
        [tokens.map(&:last).join]
      end
    end
  end
end
