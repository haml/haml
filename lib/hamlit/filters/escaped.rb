require 'hamlit/filters/base'

module Hamlit
  module Filters
    class Escaped < Base
      def compile(lines)
        ast = [:haml, :text, lines.join("\n")]
        ast = [:multi, escape_html(ast)]
        ast
      end

      private

      def escape_html(ast)
        [:escape, true, ast]
      end
    end
  end
end
