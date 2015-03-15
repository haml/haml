module Hamlit
  module Concerns
    module Indentable
      EOF = -1

      def reset_indent
        @current_indent = 0
      end

      # Return nearest line's indent level since next line. This method ignores
      # empty line. It returns -1 if next_line does not exist.
      def next_indent
        line = next_line
        return EOF unless line

        count_indent(line)
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

      def same_indent?(line)
        return false unless line
        count_indent(line) == @current_indent
      end
    end
  end
end
