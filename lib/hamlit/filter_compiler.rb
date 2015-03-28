require 'hamlit/filter'
require 'hamlit/concerns/registerable'
require 'hamlit/filters/css'
require 'hamlit/filters/javascript'
require 'hamlit/filters/ruby'

module Hamlit
  class FilterCompiler < Hamlit::Filter
    extend Concerns::Registerable

    BASE_DEPTH      = 2
    IGNORED_FILTERS = %w[ruby].freeze

    register :javascript, Filters::Javascript
    register :css,        Filters::Css
    register :ruby,       Filters::Ruby

    def on_haml_filter(name, exp)
      exp = format_expressions(name, exp)

      compiler = FilterCompiler.find(name)
      compiler.compile(exp)
    end

    private

    def format_expressions(name, lines)
      return lines if IGNORED_FILTERS.include?(name)

      lines = [''] if lines.empty?
      lines = unindent_lines(lines)

      [:multi, [:static, "\n"], *wrap_newlines(lines)]
    end

    def unindent_lines(lines)
      base = lines.first.index(/[^\s]/) || 0
      lines.map do |line|
        change_indent(line, BASE_DEPTH - base)
      end
    end

    def change_indent(line, diff)
      if diff >= 0
        ((' ' * diff) + line).gsub(/ *\Z/, '')
      else
        line.gsub(/^[[:blank:]]{#{-1 * diff}}/, '')
      end
    end

    def wrap_newlines(lines)
      ast = []
      lines.each do |line|
        ast << [:haml, :text, line]
        ast << [:static, "\n"]
      end
      ast
    end
  end
end
