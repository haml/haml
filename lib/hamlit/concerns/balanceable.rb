require 'ripper'

module Hamlit
  module Concerns
    module Balanceable
      def fetch_balanced_braces(all_tokens)
        fetch_balanced_tokens(all_tokens, :on_lbrace, :on_rbrace)
      end

      def fetch_balanced_parentheses(all_tokens)
        fetch_balanced_tokens(all_tokens, :on_lparen, :on_rparen)
      end

      def fetch_balanced_embexprs(all_tokens)
        tokens = all_tokens[1..-1] # ignore first `"`
        fetch_balanced_tokens(tokens, :on_embexpr_beg, :on_embexpr_end)
      end

      def balanced_braces_exist?(tokens)
        balanced_tokens_exist?(tokens, :on_lbrace, :on_rbrace)
      end

      def balanced_parens_exist?(tokens)
        balanced_tokens_exist?(tokens, :on_lparen, :on_rparen)
      end

      def balanced_embexprs_exist?(tokens)
        tokens = tokens[1..-1] # ignore first `"`
        balanced_tokens_exist?(tokens, :on_embexpr_beg, :on_embexpr_end)
      end

      private

      def fetch_balanced_tokens(all_tokens, open_token, close_token)
        tokens     = []
        open_count = 0

        all_tokens.each_with_index do |token, index|
          (row, col), type, str = token
          case type
          when open_token  then open_count += 1
          when close_token then open_count -= 1
          end

          tokens << token
          break if open_count == 0
        end

        tokens
      end

      def balanced_tokens_exist?(tokens, open_token, close_token)
        open_count = 0

        tokens.each do |token|
          (row, col), type, str = token
          case type
          when open_token  then open_count += 1
          when close_token then open_count -= 1
          end

          break if open_count == 0
        end

        open_count == 0
      end
    end
  end
end
