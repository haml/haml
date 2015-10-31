require 'ripper'

module Hamlit
  class HashParser
    def self.parse(text)
      self.new.parse(text)
    end

    def parse(text)
      hash = {}
      tokens = lex_as_hash(text)
      each_attr(tokens) do |attr_tokens|
        key = parse_key!(attr_tokens)
        hash[key] = attr_tokens.map(&:last).join.strip
      end
      hash
    end

    private

    def lex_as_hash(text)
      tokens = Ripper.lex('{' << text.strip << '}'.freeze)
      tokens[1..-2] || []
    end

    def parse_key!(tokens)
      _, type, str = tokens.shift
      case type
      when :on_sp
        parse_key!(tokens)
      when :on_label
        str.tr(':', '')
      else
        raise InternalError.new("Unexpected type: #{type}")
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
  end
end
