require 'ripper'

module Hamlit::StringInterpolation
  class << self
    # `code` param must be valid string literal
    def compile(code)
      [].tap do |exps|
        tokens = Ripper.lex(code.strip)
        strip_comment!(tokens)

        raise Hamlit::InternalError if tokens.size < 2
        compile_tokens!(exps, tokens)
      end
    end

    private

    def strip_comment!(tokens)
      while tokens.last && %i[on_comment on_sp].include?(tokens.last[1])
        tokens.pop
      end
    end

    def strip_quotes!(tokens)
      _, type, beg_str = tokens.shift
      raise Hamlit::InternalError if type != :on_tstring_beg

      _, type, end_str = tokens.pop
      raise Hamlit::InternalError if type != :on_tstring_end

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
