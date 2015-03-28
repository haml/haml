module Hamlit
  module Concerns
    module LineReader
      def reset_lines(lines)
        @lines = lines
        @current_lineno = -1
      end

      def current_line
        @lines[@current_lineno]
      end

      # Return nearest line ignoring empty lines.
      def next_line
        lineno = @current_lineno + 1
        while @lines[lineno] && empty_line?(@lines[lineno])
          lineno += 1
        end
        @lines[lineno]
      end

      def empty_line?(line)
        line =~ /\A *\Z/
      end

      def skip_lines
        while next_indent >= @current_indent
          @current_lineno += 1
        end
      end

      def read_lines
        lines  = []
        spaces = ' ' * (@current_indent * 2)
        while read_line?
          lines << @lines[@current_lineno + 1].gsub(/\A#{spaces}/, '')
          @current_lineno += 1
        end
        lines
      end

      private

      def read_line?
        return true if count_indent(next_line, strict: false) >= @current_indent

        line = @lines[@current_lineno + 1]
        return false unless line

        # NOTE: preserve filter also requires an empty line
        line.gsub(/ /, '').length == 0
      end
    end
  end
end

