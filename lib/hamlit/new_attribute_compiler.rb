require 'ripper'
require 'hamlit/filter'

# NewAttributeCompiler compiles new-style attributes, which is
# surrounded by parentheses.
module Hamlit
  class NewAttributeCompier < Hamlit::Filter
    TYPE_POSITION = 1

    def on_haml_attrs(*exps)
      attrs = []
      exps.map do |exp|
        case exp
        when /\A(.+)\Z/
          attrs += compile_attribute(exp)
        else
          attrs << compile(exp)
        end
      end
      [:haml, :attrs, *attrs]
    end

    private

    def compile_attribute(str)
      str    = str.gsub(/\A\(|\)\Z/, '')
      attrs  = parse_attributes(str)
      attrs.map do |key, value|
        [:html, :attr, key, [:dynamic, value]]
      end
    end

    def parse_attributes(str)
      attributes = {}

      while str.length > 0
        tokens = Ripper.lex(str)
        key = read_key!(tokens)
        val = read_value!(tokens)
        attributes[key] = val if key && val

        token = tokens.first
        break unless token

        pos   = token.first.last
        str   = str[(pos - 1)..-1]
      end

      attributes
    end

    def read_key!(tokens)
      skip_tokens!(tokens, :on_sp)
      (row, col), type, key = tokens.shift

      skip_tokens!(tokens, :on_sp)
      (row, col), type, str = tokens.shift
      raise SyntaxError if str != '='

      key
    end

    def read_value!(tokens)
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

    def skip_tokens!(tokens, *types)
      while types.include?(type_of(tokens.first))
        tokens.shift
      end
    end

    def type_of(token)
      return nil unless token
      token[TYPE_POSITION]
    end
  end
end
