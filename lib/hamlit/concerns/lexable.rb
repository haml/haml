require 'ripper'

module Hamlit
  module Concerns
    module Lexable
      TYPE_POSITION = 1

      def skip_tokens!(tokens, *types)
        while types.include?(type_of(tokens.first))
          tokens.shift
        end
      end

      def type_of(token)
        return nil unless token
        token[TYPE_POSITION]
      end

      # Convert ripper's position to StringScanner's one.
      def convert_position(text, row, col)
        return col if row <= 1

        pos   = col
        lines = text.split("\n")
        (0..(row - 2)).each do |row_index|
          pos += lines[row_index].bytesize + 1
        end
        pos
      end
    end
  end
end
