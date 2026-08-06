# frozen_string_literal: true
require 'haml/string_splitter'

module Haml
  class Filters
    class Plain < Base
      def compile(node)
        text = node.value[:text]
        text = text.rstrip unless ::Haml::Util.contains_interpolation?(text) # for compatibility
        [:multi, [:newline], *compile_plain(text)]
      end

      private

      def compile_plain(text)
        string_literal = ::Haml::Util.unescape_interpolation(text)
        compiled = StringSplitter.try_compile(string_literal)
        # Ruby that does not parse: let the generated code report it against the template,
        # rather than failing the whole compilation.
        return [[:escape, false, [:dynamic, string_literal]]] if compiled.nil?

        compiled.map do |temple|
          type, str = temple
          case type
          when :dynamic
            [:escape, false, [:dynamic, str]]
          else
            temple
          end
        end
      end
    end
  end
end
