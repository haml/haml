require 'ripper'

# FIXME: this can be refactored
module Hamlit
  module Concerns
    module Balanceable
      # Given Ripper tokens, return first brace-balanced tokens
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

      def fetch_balanced_parentheses(all_tokens)
        tokens     = []
        open_count = 0

        all_tokens.each_with_index do |token, index|
          (row, col), type, str = token
          case type
          when :on_lparen then open_count += 1
          when :on_rparen then open_count -= 1
          end

          tokens << token
          break if open_count == 0
        end

        tokens
      end

      private

      def balanced_braces_exist?(tokens)
        open_count = 0

        tokens.each do |token|
          (row, col), type, str = token
          case type
          when :on_lbrace then open_count += 1
          when :on_rbrace then open_count -= 1
          end

          break if open_count == 0
        end

        open_count == 0
      end

      def balanced_parens_exist?(tokens)
        open_count = 0

        tokens.each do |token|
          (row, col), type, str = token
          case type
          when :on_lparen then open_count += 1
          when :on_rparen then open_count -= 1
          end

          break if open_count == 0
        end

        open_count == 0
      end
    end
  end
end
