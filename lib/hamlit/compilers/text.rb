require 'hamlit/concerns/string_literal'

module Hamlit
  module Compilers
    module Text
      include Concerns::StringLiteral

      def on_haml_text(exp)
        return [:static, exp] unless contains_interpolation?(exp)

        [:dynamic, string_literal(exp)]
      end

      private

      def contains_interpolation?(str)
        /#[\{$@]/ === str
      end
    end
  end
end
