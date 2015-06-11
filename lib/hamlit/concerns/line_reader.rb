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
        line = line.rest if line.respond_to?(:rest)
        line =~ /\A *\Z/
      end

      def skip_lines
        while next_line && next_indent >= @current_indent
          @current_lineno += 1
        end
      end

      def read_lines
        lines = []
        while read_line?
          lines << @lines[@current_lineno + 1]
          @current_lineno += 1
        end
        trim_lines(lines)
      end

      private

      def trim_lines(lines)
        size = (lines.first || '').index(/[^\s]/) || 0
        lines.map { |line| line.gsub(/\A {#{size}}/, '') }
      end

      def read_line?
        return false unless next_line
        return true if next_line.index(/^#{@indent_logs.last}[ \t]/)

        line = @lines[@current_lineno + 1]
        return false unless line

        # NOTE: preserve filter also requires an empty line
        line.gsub(/ /, '').length == 0
      end
    end
  end
end

