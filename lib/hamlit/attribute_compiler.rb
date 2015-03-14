require 'ripper'
require 'temple/html/filter'

module Hamlit
  class AttributeCompiler < Temple::HTML::Filter
    TYPE_POSITION = 1

    def on_html_attrs(*exps)
      attrs = []
      exps.map do |exp|
        case exp
        when String
          attrs += compile_attribute(exp)
        else
          attrs << compile(exp)
        end
      end
      [:html, :attrs, *attrs]
    end

    private

    def compile_attribute(str)
      tokens = Ripper.lex(str)
      attrs  = parse_attributes(tokens)
      flatten_attributes(attrs).map do |key, value|
        [:html, :attr, key, [:dynamic, value]]
      end
    end

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

        skip_tokens!(tokens, :on_sp)
        raise SyntaxError if tokens.any? && type_of(tokens.shift) != :on_comma
      end

      attributes
    end

    def read_key!(tokens)
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

    def read_value!(tokens)
      result = ''
      skip_tokens!(tokens, :on_sp)

      if type_of(tokens.first) == :on_lbrace
        hash, _ = fetch_balanced_braces(tokens)
        hash.length.times { tokens.shift }
        return parse_attributes(hash)
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
