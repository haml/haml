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
        return 1 if !defined?(@indent_space) && fetch_indent(next_line).length > 0
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

        if !defined?(@indent_space) && @indent_logs.last != ''
          @indent_space = @indent_logs.last
        end
        validate_indentation_consistency!(indent)
        reject_too_deep_indentation!

        next_indent < @current_indent
      end

      def has_block?
        return false unless next_line
        return fetch_indent(next_line).length > 0 unless defined?(@indent_space)

        next_indent > @current_indent
      end

      private

      # Validate the template is using consitent indentation, 2 spaces or a tab.
      def validate_indentation_consistency!(indent)
        return false if indent.empty?
        return false if !defined?(@indent_space) || @indent_space.empty?

        unless acceptable_indent?(indent)
          syntax_error!("Inconsistent indentation: #{indent_label(indent)} used for indentation, "\
                        "but the rest of the document was indented using #{indent_label(@indent_space)}.")
        end
      end

      def acceptable_indent?(indent)
        indent = indent.dup
        while indent.match(/^#{@indent_space}/)
          indent.gsub!(/^#{@indent_space}/, '')
        end
        indent.empty?
      end

      def reject_too_deep_indentation!
        return if next_indent <= @current_indent

        if @indent_logs.length == 1
          syntax_error!('Indenting at the beginning of the document is illegal.')
        else
          syntax_error!("The line was indented #{next_indent - count_indent(current_line)} levels deeper than the previous line.")
        end
      end

      def indent_label(indent)
        return %Q{"#{indent}"} if indent.include?(' ') && indent.include?("\t")

        label  = indent.include?(' ') ? 'space' : 'tab'
        length = indent.match(/[ \t]+/).to_s.length

        "#{length} #{label}#{'s' if length > 1}"
      end

      def indent_rule
        return 0 unless defined?(@indent_space)
        @indent_space.length
      end

      def fetch_indent(str)
        str.match(/^[ \t]+/).to_s
      end
    end
  end
end
