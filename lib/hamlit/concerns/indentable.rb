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
        count_indent(next_line)
      end

      def with_indented(&block)
        @current_indent += 1
        result = block.call
        @current_indent -= 1

        result
      end

      def count_indent(line, strict: false)
        return EOF unless line
        width = line[/\A +/].to_s.length

        return (width + 1) / 2 unless strict
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
