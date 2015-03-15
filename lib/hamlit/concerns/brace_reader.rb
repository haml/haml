require 'ripper'

module Hamlit
  module Concerns
    module BraceReader
      # Return a string balancing count of braces.
      # And change the scanner position to the last brace.
      def read_brace(scanner)
        return unless scanner.match?(/{/)

        all_tokens  = Ripper.lex(scanner.rest)
        tokens      = fetch_balanced_braces(all_tokens)
        scanner.pos += tokens.last.first.last + 1
        tokens.map { |t| t.last }.join
      end

      private

      # Given Ripper tokens, return first brace-balanced tokens and rest tokens.
      def fetch_balanced_braces(all_tokens)
        tokens     = []
        open_count = 0

        all_tokens.each_with_index do |token, index|
          (row, col), type, str = token
          case type
          when :on_lbrace then open_count += 1
          when :on_rbrace then open_count -= 1
          end

          tokens << token
          break if open_count == 0
        end

        tokens
      end
    end
  end
end
