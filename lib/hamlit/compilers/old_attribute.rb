require 'hamlit/concerns/attribute_builder'
require 'hamlit/concerns/balanceable'
require 'hamlit/concerns/ripperable'

# This module compiles only old-style attribute, which is
# surrounded by brackets.
module Hamlit
  # This error is raised when hamlit copmiler decide to
  # copmile the attributes on runtime.
  class RuntimeBuild < StandardError; end

  module Compilers
    module OldAttribute
      include Concerns::AttributeBuilder
      include Concerns::Balanceable
      include Concerns::Ripperable

      # Only data can be nested for performance.
      NESTABLE_ATTRIBUTES = %w[data].freeze
      IGNORED_EXPRESSIONS = %w[false nil].freeze

      # Class and id are joined if the value is an array.
      JOIN_ATTRIBUTES = %w[class id].freeze
      JOINABLE_TOKENS = %i[on_ident on_qwords_beg on_lbracket].freeze

      # Only boolean attributes can be deleted for performance.
      BOOLEAN_ATTRIBUTES = %w[disabled readonly multiple checked autobuffer
                           autoplay controls loop selected hidden scoped async
                           defer reversed ismap seamless muted required
                           autofocus novalidate formnovalidate open pubdate
                           itemscope allowfullscreen default inert sortable
                           truespeed typemustmatch data].freeze

      def compile_old_attribute(str)
        raise RuntimeBuild unless Ripper.sexp(str)

        attrs = parse_old_attributes(str)
        assert_no_boolean_attributes!(attrs)

        format_attributes(attrs).map do |key, value|
          next true_attribute(key) if value == 'true'
          assert_static_value!(value)   if NESTABLE_ATTRIBUTES.include?(key)
          detect_joinable_value!(value) if JOIN_ATTRIBUTES.include?(key)

          [:html, :attr, key, [:dynamic, value]]
        end
      rescue RuntimeBuild
        # Give up static compilation when given string is invalid as ruby hash
        [[:runtime, str]]
      end

      private

      def format_attributes(attributes)
        attributes = flatten_attributes(attributes)
        ignore_falsy_values(attributes)
      end

      def ignore_falsy_values(attributes)
        attributes = attributes.dup
        attributes.each do |key, value|
          attributes.delete(key) if IGNORED_EXPRESSIONS.include?(value)
        end
      end

      # Give up static compilation when variables are detected.
      def assert_static_value!(value)
        tokens = Ripper.lex(value)
        tokens.each do |(row, col), type, str|
          raise RuntimeBuild if type == :on_ident
        end
      end

      # Give up static compilation when the value is a variable or an array.
      def detect_joinable_value!(value)
        tokens = Ripper.lex(value)
        tokens.each do |(row, col), type, str|
          raise RuntimeBuild if JOINABLE_TOKENS.include?(type)
        end
      end

      # Give up static compilation when attributes have deletable
      # attributes, such as 'checked'.
      def assert_no_boolean_attributes!(attrs)
        if BOOLEAN_ATTRIBUTES.any? { |key| attrs.keys.include?(key) }
          raise RuntimeBuild
        end
      end

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

      def split_hash(str)
        columns = HashParser.assoc_columns(str)
        columns = reject_nested_columns(str, columns)

        splitted  = []
        start_pos = 1
        columns.each do |end_pos|
          if str.ascii_only?
            splitted << str[start_pos..(end_pos - 1)]
          else
            splitted << str.unpack("C*")[start_pos..(end_pos - 1)].pack("C*").force_encoding('utf-8')
          end
          start_pos = end_pos + 1
        end

        splitted
      end

      def reject_nested_columns(str, columns)
        result = []
        open_count = 0
        count = {
          emb:     0,
          paren:   0,
          bracket: 0,
        }

        Ripper.lex(str).each do |(row, col), type, str|
          if columns.include?(col) && open_count == 1 && count.values.all?(&:zero?)
            result << col
          end

          case type
          when :on_lbrace
            open_count += 1
          when :on_rbrace
            open_count -= 1
          when :on_embexpr_beg
            count[:emb] += 1
          when :on_embexpr_end
            count[:emb] -= 1
          when :on_lparen
            count[:paren] += 1
          when :on_rparen
            count[:paren] -= 1
          when :on_lbracket
            count[:bracket] += 1
          when :on_rbracket
            count[:bracket] -= 1
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
