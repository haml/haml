require 'ripper'
require 'hamlit/concerns/balanceable'

module Hamlit
  module Parsers
    module Attribute
      include Concerns::Balanceable

      EMBEXPR_PREFIX = '"#'.freeze

      def parse_attributes(scanner)
        if scanner.match?(/{/)
          parse_old_attributes(scanner) + parse_new_attributes(scanner)
        else
          parse_new_attributes(scanner) + parse_old_attributes(scanner)
        end
      end

      private

      # NOTE: Old attributes are not valid as Ruby expression.
      # So Ripper is broken if you give an original expression to it.
      # This method bypasses it by changing expression to string interpolation.
      # Ideally you should implement an original lexer for haml old attributes.
      def parse_old_attributes(scanner)
        return [] unless scanner.match?(/{/)

        tokens = try_lex(EMBEXPR_PREFIX + scanner.rest)
        until balanced_embexprs_exist?(tokens)
          @current_lineno += 1
          break unless @lines[@current_lineno]
          scanner.concat(current_line)
          tokens = try_lex(EMBEXPR_PREFIX + scanner.rest)
        end

        tokens = fetch_balanced_embexprs(tokens)
        scanner.pos += tokens.last.first.last - 1 # remove EMBEXPR_PREFIX's offset
        [tokens.map(&:last).join.gsub(/\A#/, '')]
      end

      def parse_new_attributes(scanner)
        return [] unless scanner.match?(/\(/)

        tokens = Ripper.lex(scanner.rest)
        until balanced_parens_exist?(tokens)
          @current_lineno += 1
          break unless @lines[@current_lineno]
          scanner.concat(current_line)
          tokens = Ripper.lex(scanner.rest)
        end

        tokens = fetch_balanced_parentheses(tokens)
        scanner.pos += tokens.last.first.last + 1
        [tokens.map(&:last).join]
      end

      # Ripper.lex and reject tokens whose row is 0 (invalid).
      # This should be used only for an expression which can
      # be invalid as Ruby and valid as haml.
      def try_lex(str)
        Ripper.lex(str).reject do |(row, col), type, str|
          row == 0
        end
      end
    end
  end
end
