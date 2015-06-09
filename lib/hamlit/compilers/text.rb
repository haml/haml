require 'hamlit/concerns/error'
require 'hamlit/concerns/escapable'
require 'hamlit/concerns/included'
require 'hamlit/concerns/lexable'
require 'hamlit/concerns/string_interpolation'

module Hamlit
  module Compilers
    module Text
      extend Concerns::Included
      include Concerns::Error
      include Concerns::Lexable
      include Concerns::StringInterpolation

      included do
        include Concerns::Escapable
      end

      # To ask ripper to consider a given text as string literal,
      # I change "foo" to "%!foo!".
      # This constant is the candidates for the literal surrounder.
      STRING_MARKERS = %w[' " ! @ $ % ^ & * | =].freeze

      # Return static and dynamic temple ast.
      # It splits expression to optimize because string interpolation is slow.
      def on_haml_text(exp, escape_html = true)
        return syntax_error('Unbalanced brackets.') unless valid_interpolation?(exp)
        return static_text(exp) unless contains_interpolation?(exp)

        marker = find_string_marker(exp)
        return [:dynamic, string_literal(exp)] unless marker

        open_pos, close_pos = find_interpolation(exp, marker)
        return static_text(exp) unless open_pos && close_pos

        pre  = exp.byteslice(0...open_pos)
        body = exp.byteslice((open_pos + 2)...close_pos)
        post = exp.byteslice((close_pos + 1)...exp.bytesize)

        body_ast = escape_html ? escape_html([:dynamic, body]) : [:dynamic, body]
        [:multi, [:static, pre], body_ast, on_haml_text(post)]
      end

      def find_interpolation(exp, marker)
        return unless contains_interpolation?(exp)

        offset     = 2 # 2 is the length of '%' and marker
        open_pos   = nil
        close_pos  = nil
        open_count = 0
        literal    = literalify_string(exp, marker)

        Ripper.lex(literal).each do |(row, col), type, str|
          case type
          when :on_embexpr_beg
            open_pos = shifted_position(exp, row, col, offset) if open_count == 0
            open_count += 1
          when :on_embexpr_end
            open_count -= 1
            return [open_pos, shifted_position(exp, row, col, offset)] if open_count == 0
          end
          open_count
        end

        nil
      end

      private

      def valid_interpolation?(exp)
        marker = find_string_marker(exp)
        return true unless marker # give up checking

        literal = literalify_string(exp, marker)
        open_count = 0

        Ripper.lex(literal).each do |(row, col), type, str|
          case type
          when :on_embexpr_beg
            open_count += 1
          when :on_embexpr_end
            open_count -= 1
          end
        end
        open_count == 0
      end

      # :static can't treat backslash properly
      def static_text(exp)
        return [:dynamic, string_literal(exp)] if exp.include?('\\')
        [:static, exp]
      end

      def find_string_marker(text)
        STRING_MARKERS.each do |marker|
          return marker unless text.include?(marker)
        end
        nil
      end

      def literalify_string(exp, marker)
        "%#{marker}#{exp}#{marker}"
      end

      # In this compiler, only first line is shifted 2 chars.
      def shifted_position(exp, row, col, offset)
        return col - offset if row <= 1
        convert_position(exp, row, col)
      end
    end
  end
end
