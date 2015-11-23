require 'ripper'
require 'hamlit/ruby_expression'

module Hamlit::StringInterpolation
  class << self
    # `code` param must be valid string literal
    def compile(code)
      [].tap do |exps|
        code   = Hamlit::RubyExpression.strip_comment(code)
        tokens = Ripper.lex(code)

        if tokens.size < 2
          raise Hamlit::InternalError.new("Expected token size >= 2 but got: #{tokens.size}")
        end
        compile_tokens!(exps, tokens)
      end
    end

    # Compile Hamlit::HamlParser::ParseNode into Temple AST.
    def compile_node(node, key)
      [:multi].tap do |temple|
        compile(node.value[key]).each do |type, value|
          case type
          when :static
            value = Temple::Utils.escape_html(value) if node.value[:escape_html]
            value = ::Hamlit::HamlHelpers.find_and_preserve(value, %w(textarea pre code)) if node.value[:preserve]
            temple << [:static, value]
          when :dynamic
            temple << [:escape, node.value[:escape_html] || node.value[:escape_interpolation], [:dynamic, value]]
          end
        end
      end
    end

    private

    def strip_quotes!(tokens)
      _, type, beg_str = tokens.shift
      if type != :on_tstring_beg
        raise Hamlit::InternalError.new("Expected :on_tstring_beg but got: #{type}")
      end

      _, type, end_str = tokens.pop
      if type != :on_tstring_end
        raise Hamlit::InternalError.new("Expected :on_tstring_end but got: #{type}")
      end

      [beg_str, end_str]
    end

    def compile_tokens!(exps, tokens)
      beg_str, end_str = strip_quotes!(tokens)

      until tokens.empty?
        _, type, str = tokens.shift

        case type
        when :on_tstring_content
          exps << [:static, eval("#{beg_str}#{str}#{end_str}")]
        when :on_embexpr_beg
          embedded = shift_balanced_embexpr(tokens)
          exps << [:dynamic, embedded] unless embedded.empty?
        end
      end
    end

    def shift_balanced_embexpr(tokens)
      String.new.tap do |embedded|
        embexpr_open = 1

        until tokens.empty?
          _, type, str = tokens.shift
          case type
          when :on_embexpr_beg
            embexpr_open += 1
          when :on_embexpr_end
            embexpr_open -= 1
            break if embexpr_open == 0
          end

          embedded << str
        end
      end
    end
  end
end
