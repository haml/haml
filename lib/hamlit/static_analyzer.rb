require 'hamlit/syntax_checker'

module Hamlit
  class StaticAnalyzer
    STATIC_TOKENS = %i[
      on_tstring_beg on_tstring_end on_tstring_content
      on_embexpr_beg on_embexpr_end
      on_lbracket on_rbracket
      on_lparen on_rparen
      on_int on_float on_imaginary
      on_comma on_sp
    ].freeze

    DYNAMIC_TOKENS = %i[
      on_ident on_op on_period
    ].freeze

    STATIC_KEYWORDS = %w[
      true false nil
    ].freeze

    def self.static?(exp)
      return false if exp.nil? || exp.strip.empty?
      return false if SyntaxChecker.syntax_error?(exp)

      Ripper.lex(exp).each do |(_, col), token, str|
        case token
        when *STATIC_TOKENS
          # noop
        when :on_kw
          case str
          when *STATIC_KEYWORDS
            # noop
          else
            return false
          end
        when *DYNAMIC_TOKENS
          return false
        else
          return false
        end
      end
      true
    end
  end
end
