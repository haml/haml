require 'hamlit/attribute'
require 'hamlit/concerns/attribute_builder'
require 'hamlit/concerns/balanceable'
require 'hamlit/concerns/ripperable'

# This module compiles only old-style attribute, which is
# surrounded by brackets.
module Hamlit
  module Compilers
    module OldAttribute
      include Concerns::AttributeBuilder
      include Concerns::Balanceable
      include Concerns::Ripperable

      def compile_old_attribute(str)
        return runtime_build(str) unless Ripper.sexp(str)

        attrs = parse_old_attributes(str)
        flatten_attributes(attrs).map do |key, value|
          next true_attribute(key) if value == 'true'
          [:html, :attr, key, [:dynamic, value]]
        end
      end

      private

      # Parse brace-balanced string and return the result as hash
      def parse_old_attributes(str)
        attributes = {}

        split_hash(str).each do |attr|
          tokens = Ripper.lex("{#{attr}")
          tokens = tokens.drop(1)

          key = read_hash_key!(tokens)
          val = tokens.map(&:last).join.strip

          skip_tokens!(tokens, :on_sp)
          if type_of(tokens.first) == :on_lbrace
            val = parse_old_attributes(val)
          end

          attributes[key] = val if key
        end

        attributes
      end

      def read_hash_key!(tokens)
        skip_tokens!(tokens, :on_sp)

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

        raise SyntaxError if type_of(tokens.shift) != :on_tstring_end
        str
      end

      def assert_rocket!(tokens, *types)
        skip_tokens!(tokens, :on_sp)
        (row, col), type, str = tokens.shift

        raise SyntaxError unless type == :on_op && str == '=>'
      end

      def runtime_build(str)
        str = str.gsub(/(\A\{|\}\Z)/, '')
        quote = options[:attr_quote].inspect
        code = "::Hamlit::Attribute.build(#{quote}, #{str})"
        [[:dynamic, code]]
      end

      def split_hash(str)
        columns = HashParser.assoc_columns(str)
        columns = reject_nested_columns(str, columns)

        splitted  = []
        start_pos = 1
        columns.each do |end_pos|
          splitted << str[start_pos..(end_pos - 1)]
          start_pos = end_pos + 1
        end

        splitted
      end

      def reject_nested_columns(str, columns)
        result     = []
        open_count = 0

        Ripper.lex(str).each do |(row, col), type, str|
          if columns.include?(col) && open_count == 1
            result << col
          end

          case type
          when :on_lbrace
            open_count += 1
          when :on_rbrace
            open_count -= 1
          end
        end
        result
      end

      class HashParser < Ripper
        attr_reader :columns

        def self.assoc_columns(src)
          parser = new(src)
          parser.parse
          parser.columns
        end

        def initialize(src)
          super(src)
          @columns = []
        end

        private

        def on_assoc_new(*args)
          @columns << column - 1
        end
      end
    end
  end
end
