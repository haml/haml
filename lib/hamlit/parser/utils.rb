module Hamlit
  class Parser
    module Utils
      EOF = -1

      # This is a requirement for temple compilers
      def initialize(options = {})
      end

      private

      # Reset the parser state.
      def reset(template)
        @lines = template.split("\n")
        @current_lineno = -1
        @current_indent = 0
      end

      # Return nearest line's indent level since next line. This method ignores
      # empty line. It returns -1 if next_line does not exist.
      def next_indent
        line = next_line
        return EOF unless line

        count_indent(line)
      end

      # Return nearest line ignoring empty lines.
      def next_line
        lineno = @current_lineno + 1
        while @lines[lineno] && empty_line?(@lines[lineno])
          lineno += 1
        end
        @lines[lineno]
      end

      def with_indented(&block)
        @current_indent += 1
        result = block.call
        @current_indent -= 1

        result
      end

      def count_indent(line)
        width = line[/\A +/].to_s.length
        raise SyntaxError if width.odd?

        width / 2
      end

      def empty_line?(line)
        line =~ /\A *\Z/
      end
    end
  end
end

