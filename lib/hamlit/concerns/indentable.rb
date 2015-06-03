require 'hamlit/concerns/error'

module Hamlit
  EOF = -1

  module Concerns
    module Indentable
      include Concerns::Error

      def reset_indent
        @current_indent = 0
      end

      # Return nearest line's indent level since next line. This method ignores
      # empty line. It returns -1 if next_line does not exist.
      def next_indent
        count_indent(next_line)
      end

      def next_width
        count_width(next_line)
      end

      def with_indented(&block)
        @current_indent += 1
        block.call
      ensure
        @current_indent -= 1
      end

      def count_indent(line, strict: false)
        return EOF unless line
        width = count_width(line)

        return (width + 1) / 2 unless strict
        compile_error!('Expected to count even-width indent') if width.odd?

        width / 2
      end

      def count_width(line)
        return EOF unless line
        line[/\A +/].to_s.length
      end

      def same_indent?(line)
        return false unless line
        count_indent(line) == @current_indent
      end

      # Validate the template is using consitent indentation, 2 spaces or a tab.
      def validate_indentation!(template)
        last_indent = ''

        indents = template.scan(/^[ \t]+/)
        indents.each do |indent|
          if last_indent.include?(' ') && indent.include?("\t") ||
              last_indent.include?("\t") && indent.include?(' ')
            syntax_error!(%Q{Inconsistent indentation: #{indent_label(indent)} used for indentation, but the rest of the document was indented using #{indent_label(last_indent)}.})
          end

          last_indent = indent
        end
      end

      def indent_label(indent)
        return %Q{"#{indent}"} if indent.include?(' ') && indent.include?("\t")

        label  = indent.include?(' ') ? 'space' : 'tab'
        length = indent.match(/[ \t]+/).to_s.length

        "#{length} #{label}#{'s' if length > 1}"
      end

      # Replace hard tabs into 2 spaces
      def replace_hard_tabs(template)
        lines = []
        template.each_line do |line|
          lines << line.gsub(/^\t+/) do |match|
            ' ' * (match.length * 2)
          end
        end
        lines.join
      end
    end
  end
end
