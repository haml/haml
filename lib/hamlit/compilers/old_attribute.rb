require 'ripper'
require 'hamlit/concerns/balanceable'

# This module compiles only old-style attribute, which is
# surrounded by brackets.
# FIXME: remove duplicated code with NewAttribute
module Hamlit
  module Compilers
    module OldAttribute
      include Concerns::Balanceable

      TYPE_POSITION = 1

      def compile_old_attribute(str)
        tokens = Ripper.lex(str)
        attrs  = parse_old_attributes(tokens)
        flatten_attributes(attrs).map do |key, value|
          [:html, :attr, key, [:dynamic, value]]
        end
      end

      private

      def flatten_attributes(attributes)
        flattened = {}

        attributes.each do |key, value|
          case value
          when Hash
            flatten_attributes(value).each do |k, v|
              flattened["#{key}-#{k}"] = v
            end
          else
            flattened[key] = value
          end
        end
        flattened
      end

      # Parse brace-balanced tokens and return the result as hash
      def parse_old_attributes(tokens)
        tokens = tokens.slice(1..-2) # strip braces
        attributes = {}

        while tokens && tokens.any?
          key = read_hash_key!(tokens)
          val = read_hash_value!(tokens)
          attributes[key] = val if key && val

          hash_skip_tokens!(tokens, :on_sp)
          raise SyntaxError if tokens.any? && hash_type_of(tokens.shift) != :on_comma
        end

        attributes
      end

      def read_hash_key!(tokens)
        hash_skip_tokens!(tokens, :on_sp)

        (row, col), type, str = tokens.shift
        case type
        when :on_label
          str.gsub!(/:\Z/, '')
        when :on_symbeg
          if %w[:" :'].include?(str)
            str = read_string!(tokens)
          else
            (row, col), type, str = tokens.shift
          end
          assert_rocket!(tokens)
        when :on_tstring_beg
          str = read_string!(tokens)
          assert_rocket!(tokens)
        end
        str
      end

      def read_string!(tokens)
        (row, col), type, str = tokens.shift
        return '' if type == :on_tstring_end

        raise SyntaxError if hash_type_of(tokens.shift) != :on_tstring_end
        str
      end

      def read_hash_value!(tokens)
        result = ''
        hash_skip_tokens!(tokens, :on_sp)

        if hash_type_of(tokens.first) == :on_lbrace
          hash = fetch_balanced_braces(tokens)
          hash.length.times { tokens.shift }
          return parse_old_attributes(hash)
        end

        while token = tokens.shift
          (row, col), type, str = token
          case type
          when :on_sp
            next
          when :on_comma
            tokens.unshift(token)
            break
          end

          result += str
        end
        result
      end

      def hash_skip_tokens!(tokens, *types)
        while types.include?(hash_type_of(tokens.first))
          tokens.shift
        end
      end

      def assert_rocket!(tokens, *types)
        hash_skip_tokens!(tokens, :on_sp)
        (row, col), type, str = tokens.shift

        raise SyntaxError unless type == :on_op && str == '=>'
      end

      def hash_type_of(token)
        return nil unless token
        token[TYPE_POSITION]
      end
    end
  end
end
