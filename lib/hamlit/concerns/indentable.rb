require 'hamlit/concerns/error'

module Hamlit
  EOF = -1

  module Concerns
    module Indentable
      include Concerns::Error

      def reset_indent
        @indent_logs    = []
        @current_indent = 0
      end

      # Return nearest line's indent level since next line. This method ignores
      # empty line. It returns -1 if next_line does not exist.
      def next_indent
        return 1 if !@indent_space && fetch_indent(next_line).length > 0
        count_indent(next_line)
      end

      def with_indented(&block)
        @current_indent += 1
        block.call
      ensure
        @current_indent -= 1
      end

      def count_indent(line)
        return EOF unless line
        return 0 if indent_rule == 0

        line.match(/\A[ \t]+/).to_s.length / indent_rule
      end

      def same_indent?(line)
        return false unless line
        count_indent(line) == @current_indent
      end

      # Validate current line's indentation
      def validate_indentation!(ast)
        return true unless next_line

        indent = fetch_indent(next_line)
        if indent.include?(' ') && indent.include?("\t")
          syntax_error!("Indentation can't use both tabs and spaces.")
        end
        @indent_logs << indent

        if !@indent_space && @indent_logs.last != ''
          @indent_space = @indent_logs.last
        end
        validate_indentation_consistency!(indent)

        next_indent != @current_indent
      end

      def has_block?
        return false unless next_line
        return fetch_indent(next_line).length > 0 unless @indent_space

        next_indent > @current_indent
      end

      private

      # Validate the template is using consitent indentation, 2 spaces or a tab.
      def validate_indentation_consistency!(indent)
        return false if indent.empty?
        return false if !@indent_space || @indent_space.empty?

        if indent[0] != @indent_space[0] || indent.length < @indent_space.length
          syntax_error!("Inconsistent indentation: #{indent_label(indent)} used for indentation, "\
                        "but the rest of the document was indented using #{indent_label(@indent_space)}.")
        end
      end

      def indent_label(indent)
        return %Q{"#{indent}"} if indent.include?(' ') && indent.include?("\t")

        label  = indent.include?(' ') ? 'space' : 'tab'
        length = indent.match(/[ \t]+/).to_s.length

        "#{length} #{label}#{'s' if length > 1}"
      end

      def indent_rule
        (@indent_space || '').length
      end

      def fetch_indent(str)
        str.match(/^[ \t]+/).to_s
      end
    end
  end
end
