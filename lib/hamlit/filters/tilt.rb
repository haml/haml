require 'tilt'
require 'hamlit/concerns/string_interpolation'
require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Tilt < Filters::Base
      include Concerns::StringInterpolation

      def self.render(name, source)
        result = ::Tilt["t.#{name}"].new { source }.render
        indent_source(result, indent_width: 2)
      end

      private

      def compile_with_tilt(name, source, ast)
        return runtime_compile(name, source, ast) if contains_interpolation?(source)

        result  = [:static, Filters::Tilt.render(name, source)]
        content = [:multi, [:static, "\n"], result]
        ast << content
      end

      def runtime_compile(name, source, ast)
        literal = string_literal(source)
        code    = "::Hamlit::Filters::Tilt.render(#{name.inspect}, #{literal})"
        content = [:multi, [:static, "\n"], [:dynamic, code]]
        ast << content
      end
    end
  end
end
