require 'hamlit/concerns/line_reader'

module Hamlit
  module Parsers
    module Multiline
      include Concerns::LineReader

      SPACED_BLOCK_REGEXP = /do +\| *[^\|]+ *\|\Z/

      def preprocess_multilines(template)
        reset_lines(template.split("\n"))
        result = []

        while @lines[@current_lineno + 1]
          @current_lineno += 1

          unless end_with_pipe?(current_line)
            result << current_line
            next
          end

          prefix = current_line[/\A */]
          lines  = scan_multilines

          result << prefix + build_multiline(lines)
          (lines.length - 1).times { result << '' }
        end
        result.map { |line| "#{line}\n" }.join
      end

      private

      def end_with_pipe?(line)
        return false unless line
        return false if line =~ SPACED_BLOCK_REGEXP

        line.strip =~ / \|\Z/
      end

      def scan_multilines
        lines = []
        while end_with_pipe?(current_line)
          lines << current_line
          @current_lineno += 1
        end
        @current_lineno -= 1
        lines
      end

      def build_multiline(lines)
        lines = lines.map do |line|
          line.strip.gsub(/ *\|\Z/, '')
        end
        lines.join(' ')
      end
    end
  end
end
