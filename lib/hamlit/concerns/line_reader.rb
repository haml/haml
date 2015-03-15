module Hamlit
  module Concerns
    module LineReader
      def reset_lines(lines)
        @lines = lines
        @current_lineno = -1
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
    end
  end
end

