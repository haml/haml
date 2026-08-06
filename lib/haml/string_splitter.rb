# frozen_string_literal: true
require 'ripper'
require 'haml/ruby_expression'

module Haml
  # Compile [:dynamic, "foo#{bar}"] to [:multi, [:static, 'foo'], [:dynamic, 'bar']]
  class StringSplitter < Temple::Filter
    class << self
      # `code` param must be valid string literal
      def compile(code)
        [].tap do |exps|
          tokens = Ripper.lex(code.strip)
          tokens.pop while tokens.last && [:on_comment, :on_sp].include?(tokens.last[1])

          if tokens.size < 2
            raise(Haml::InternalError, "Expected token size >= 2 but got: #{tokens.size}")
          end
          compile_tokens!(exps, tokens)
        end
      end

      private

      def strip_quotes!(tokens)
        _, type, beg_str = tokens.shift
        if type != :on_tstring_beg
          raise(Haml::InternalError, "Expected :on_tstring_beg but got: #{type}")
        end

        _, type, end_str = tokens.pop
        if type != :on_tstring_end
          raise(Haml::InternalError, "Expected :on_tstring_end but got: #{type}")
        end

        [beg_str, end_str]
      end

      def compile_tokens!(exps, tokens)
        beg_str, end_str = strip_quotes!(tokens)

        until tokens.empty?
          _, type, str = tokens.shift

          case type
          when :on_tstring_content
            beg_str, end_str = escape_quotes(beg_str, end_str)
            exps << [:static, eval("#{beg_str}#{str}#{end_str}").to_s]
          when :on_embexpr_beg
            embedded = shift_balanced_embexpr(tokens)
            exps << [:dynamic, embedded] unless embedded.empty?
          end
        end
      end

      # Some quotes are split-unsafe. Replace such quotes with null characters.
      def escape_quotes(beg_str, end_str)
        case [beg_str[-1], end_str]
        when ['(', ')'], ['[', ']'], ['{', '}']
          [beg_str.sub(/.\z/) { "\0" }, "\0"]
        else
          [beg_str, end_str]
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

    def on_dynamic(code)
      return [:dynamic, code] unless RubyExpression.string_literal?(code)
      return [:dynamic, code] if code.include?("\n")

      temple = [:multi]
      StringSplitter.compile(code).each do |type, content|
        case type
        when :static
          temple << [:static, content]
        when :dynamic
          temple << on_dynamic(content)
        end
      end
      temple
    end
  end
end
