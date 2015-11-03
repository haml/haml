require 'ripper'

module Hamlit
  class HashParser
    class ParseSkip < StandardError
    end

    def self.parse(text)
      self.new.parse(text)
    end

    def parse(text)
      exp = '{' << text.strip << '}'.freeze
      return if syntax_error?(exp)

      hash = {}
      tokens = Ripper.lex(exp)[1..-2] || []
      each_attr(tokens) do |attr_tokens|
        key = parse_key!(attr_tokens)
        hash[key] = attr_tokens.map(&:last).join.strip
      end
      hash
    rescue ParseSkip
      nil
    end

    private

    def parse_key!(tokens)
      _, type, str = tokens.shift
      case type
      when :on_sp
        parse_key!(tokens)
      when :on_label
        str.tr(':'.freeze, ''.freeze)
      when :on_symbeg
        _, _, key = tokens.shift
        assert_type!(tokens.shift, :on_tstring_end) if str != ':'.freeze
        skip_until_hash_rocket!(tokens)
        key
      when :on_tstring_beg
        _, _, key = tokens.shift
        next_token = tokens.shift
        unless next_token[1] == :on_label_end
          assert_type!(next_token, :on_tstring_end)
          skip_until_hash_rocket!(tokens)
        end
        key
      else
        raise InternalError.new("Unexpected type: #{type}")
      end
    end

    def assert_type!(token, type)
      raise ParseSkip if token[1] != type
    end

    def skip_until_hash_rocket!(tokens)
      until tokens.empty?
        _, type, str = tokens.shift
        break if type == :on_op && str == '=>'.freeze
      end
    end

    def each_attr(tokens)
      attr_tokens = []
      tokens.each do |token|
        (row, col), type, str = token
        case type
        when :on_comma
          yield(attr_tokens)
          attr_tokens = []
        else
          attr_tokens << token
        end
      end
      yield(attr_tokens) unless attr_tokens.empty?
    end

    def syntax_error?(code)
      ParseErrorChecker.new(code).parse
      false
    rescue ParseErrorChecker::ParseError
      true
    end
  end

  class ParseErrorChecker < Ripper
    class ParseError < StandardError
    end

    private

    def on_parse_error(*)
      raise ParseError
    end
  end
end
