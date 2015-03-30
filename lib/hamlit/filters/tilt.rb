require 'tilt'
require 'hamlit/concerns/string_interpolation'
require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Tilt < Filters::Base
      include Concerns::StringInterpolation

      def self.render(name, source, indent_width: 2)
        result = ::Tilt["t.#{name}"].new { source }.render
        indent_source(result, indent_width: indent_width)
      end

      private

      def compile_with_tilt(name, source, ast, indent_width: 2)
        if contains_interpolation?(source)
          return runtime_compile(name, source, ast, indent_width: indent_width)
        end

        content = [:static, Filters::Tilt.render(name, source, indent_width: indent_width)]
        build_ast(ast, content)
      end

      def runtime_compile(name, source, ast, indent_width: 2)
        literal = string_literal(source)
        code    = "::Hamlit::Filters::Tilt.render(#{name.inspect}, #{literal}, indent_width: #{indent_width})"
        content = [:dynamic, code]
        build_ast(ast, content)
      end

      def build_ast(ast, content)
        return content if ast.empty?

        content = [:multi, [:static, "\n"], content]
        ast << content
      end
    end
  end
end
