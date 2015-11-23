require 'hamlit/ruby_expression'

module Hamlit
  class StaticAnalyzer
    STATIC_TOKENS = %i[
      on_tstring_beg on_tstring_end on_tstring_content
      on_embexpr_beg on_embexpr_end
      on_lbracket on_rbracket
      on_lparen on_rparen
      on_lbrace on_rbrace on_label
      on_int on_float on_imaginary
      on_comma on_sp
    ].freeze

    DYNAMIC_TOKENS = %i[
      on_ident on_period
    ].freeze

    STATIC_KEYWORDS = %w[
      true false nil
    ].freeze

    STATIC_OPERATORS = %w[
      =>
    ].freeze

    def self.static?(exp)
      return false if exp.nil? || exp.strip.empty?
      return false if RubyExpression.syntax_error?(exp)

      Ripper.lex(exp).each do |(_, col), token, str|
        case token
        when *STATIC_TOKENS
          # noop
        when :on_kw
          return false unless STATIC_KEYWORDS.include?(str)
        when :on_op
          return false unless STATIC_OPERATORS.include?(str)
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
