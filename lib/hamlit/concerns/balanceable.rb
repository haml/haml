require 'ripper'
require 'hamlit/concerns/lexable'

module Hamlit
  module Concerns
    module Balanceable
      include Lexable

      def fetch_balanced_braces(all_tokens)
        fetch_balanced_tokens(all_tokens, :on_lbrace, :on_rbrace)
      end

      def fetch_balanced_parentheses(all_tokens)
        fetch_balanced_tokens(all_tokens, :on_lparen, :on_rparen)
      end

      def fetch_balanced_embexprs(all_tokens, start_count: 0)
        fetch_balanced_tokens(all_tokens, :on_embexpr_beg, :on_embexpr_end, start_count: start_count)
      end

      def balanced_braces_exist?(tokens)
        balanced_tokens_exist?(tokens, :on_lbrace, :on_rbrace)
      end

      def balanced_parens_exist?(tokens)
        balanced_tokens_exist?(tokens, :on_lparen, :on_rparen)
      end

      def balanced_embexprs_exist?(tokens, start_count: 0)
        balanced_tokens_exist?(tokens, :on_embexpr_beg, :on_embexpr_end, start_count: start_count)
      end

      private

      def fetch_balanced_tokens(all_tokens, open_token, close_token, start_count: 0)
        tokens     = []
        open_count = start_count

        all_tokens.each_with_index do |token, index|
          case type_of(token)
          when open_token  then open_count += 1
          when close_token then open_count -= 1
          end

          tokens << token
          break if open_count == 0
        end

        tokens
      end

      def balanced_tokens_exist?(tokens, open_token, close_token, start_count: 0)
        open_count = start_count

        tokens.each do |token|
          case type_of(token)
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
