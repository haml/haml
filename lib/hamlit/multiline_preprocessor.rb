require 'temple'
require 'hamlit/concerns/line_reader'

module Hamlit
  class MultilinePreprocessor < Temple::Parser
    include Concerns::LineReader

    def call(template)
      reset_lines(template.split("\n"))
      preprocess_multilines
    end

    private

    def preprocess_multilines
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

    def end_with_pipe?(line)
      return false unless line
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
