require 'hamlit/concerns/lexable'

# This module compiles new-style attributes, which is
# surrounded by parentheses.
module Hamlit
  module Compilers
    module NewAttribute
      include Concerns::Lexable

      def compile_new_attribute(str)
        str   = str.gsub(/\A\(|\)\Z/, '')
        attrs = parse_new_attributes(str)
        attrs.map do |key, value|
          next true_attribute(key) if value == 'true'
          [:html, :attr, key, [:dynamic, value]]
        end
      end

      private

      def parse_new_attributes(str)
        attributes = {}

        while str.length > 0
          tokens = Ripper.lex(str)
          key = read_key!(tokens)
          val = read_value!(tokens)
          if key && val
            attributes[key] = val
          elsif key
            attributes[key] = 'true'
          end

          token = tokens.first
          break unless token

          pos = convert_position(str, *token.first)
          str = str[pos..-1]
        end

        attributes
      end

      def read_key!(tokens)
        skip_tokens!(tokens, :on_sp, :on_nl, :on_ignored_nl)
        (row, col), type, key = tokens.shift

        while tokens.any? && tokens.first[2] == '-'
          tokens.shift

          (row, col), type, part = tokens.shift

          key = "#{key}-#{part}"
        end

        key
      end

      def read_value!(tokens)
        skip_tokens!(tokens, :on_sp)
        (row, col), type, str = tokens.shift
        return nil if str != '='

        skip_tokens!(tokens, :on_sp)
        return if tokens.empty?

        case tokens.first[TYPE_POSITION]
        when :on_tstring_beg
          val = fetch_balanced_quotes(tokens)
        else
          val = fetch_until(tokens, :on_sp)
        end
        val.length.times { tokens.shift }
        val.map(&:last).join
      end

      def fetch_balanced_quotes(all_tokens)
        tokens     = []
        open_count = 0

        all_tokens.each do |token|
          (row, col), type, str = token
          case type
          when :on_tstring_beg then open_count += 1
          when :on_tstring_end then open_count -= 1
          end

          tokens << token
          break if open_count == 0
        end

        tokens
      end

      def fetch_until(all_tokens, type)
        tokens = []

        all_tokens.each do |token|
          break if token[TYPE_POSITION] == type
          tokens << token
        end

        tokens
      end

      def true_attribute(key)
        case options[:format]
        when :xhtml
          [:html, :attr, key, [:static, key]]
        else
          [:html, :attr, key, [:multi]]
        end
      end
    end
  end
end
