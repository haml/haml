require 'ripper'
require 'hamlit/concerns/balanceable'
require 'hamlit/concerns/lexable'

module Hamlit
  module Parsers
    module Attribute
      include Concerns::Balanceable
      include Concerns::Lexable

      ATTRIBUTE_BEGIN     = '{'.freeze
      METHOD_CALL_PREFIX  = 'a('.freeze
      BALANCE_START_COUNT = 1

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
      # This method bypasses it by changing expression to method call.
      # Ideally you should implement an original lexer for haml old attributes.
      def parse_old_attributes(scanner)
        return [] unless scanner.match?(/{/)

        tokens = Ripper.lex(scanner.rest.sub(ATTRIBUTE_BEGIN, METHOD_CALL_PREFIX))
        until balanced_embexprs_exist?(tokens, start_count: BALANCE_START_COUNT)
          @current_lineno += 1
          break unless @lines[@current_lineno]
          scanner.concat(current_line)
          tokens = Ripper.lex(scanner.rest.sub(ATTRIBUTE_BEGIN, METHOD_CALL_PREFIX))
        end

        tokens = fetch_balanced_embexprs(tokens, start_count: BALANCE_START_COUNT)
        scanner.pos += tokens.last.first.last
        [tokens.map(&:last).join.sub(METHOD_CALL_PREFIX, ATTRIBUTE_BEGIN)]
      end

      def parse_new_attributes(scanner)
        return [] unless scanner.match?(/\(/)

        tokens = Ripper.lex(scanner.rest)
        until balanced_parens_exist?(tokens)
          @current_lineno += 1
          break unless @lines[@current_lineno]
          scanner.concat("\n#{current_line}")
          tokens = Ripper.lex(scanner.rest)
        end

        tokens = fetch_balanced_parentheses(tokens)
        text   = tokens.map(&:last).join
        scanner.pos += convert_position(text, *tokens.last.first) + 1
        [text]
      end
    end
  end
end
