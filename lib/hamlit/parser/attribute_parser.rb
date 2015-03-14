require 'ripper'

module Hamlit
  class Parser
    class AttributeParser
      class << self
        TYPE_POSITION = 1

        def parse(scanner)
          return {} unless scanner.match?(/{/)

          tokens = scan_balanced_braces(scanner)
          parse_attributes(tokens)
        end

        private

        # Return tokens lexed by Ripper, balancing count of braces.
        # And change the scanner position to the last brace.
        def scan_balanced_braces(scanner)
          all_tokens  = Ripper.lex(scanner.rest)
          tokens, _   = fetch_balanced_braces(all_tokens)
          scanner.pos += tokens.last.first.last + 1
          tokens
        end

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

          [tokens, all_tokens - tokens]
        end

        # Parse brace-balanced tokens and return the result as hash
        def parse_attributes(tokens)
          tokens = tokens[1..-2] # strip braces
          attributes = {}

          while tokens && tokens.any?
            key = read_key!(tokens)
            val = read_value!(tokens)
            attributes[key] = val if key && val
          end

          attributes
        end

        def read_key!(tokens)
          skip_tokens!(tokens, :on_sp)

          (row, col), type, str = tokens.shift
          case type
          when :on_label
            str.gsub(/:\Z/, '')
          when :on_symbeg
            (row, col), type, str = tokens.shift
            assert_rocket!(tokens)
            str
          end
        end

        def read_value!(tokens)
          result = ''

          while token = tokens.shift
            (row, col), type, str = token
            case type
            when :on_sp
              next
            when :on_comma
              break
            end

            result += str
          end
          result
        end

        def skip_tokens!(tokens, *types)
          while types.include?(type_of(tokens.first))
            tokens.shift
          end
        end

        def assert_rocket!(tokens, *types)
          skip_tokens!(tokens, :on_sp)
          (row, col), type, str = tokens.shift
          raise SyntaxError unless type == :on_op && str == '=>'
        end

        def type_of(token)
          return nil unless token
          token[TYPE_POSITION]
        end
      end
    end
  end
end
