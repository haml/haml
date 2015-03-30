require 'hamlit/concerns/string_literal'

module Hamlit
  module Compilers
    module Text
      include Concerns::StringLiteral

      def on_haml_text(exp)
        return [:static, exp] unless contains_interpolation?(exp)

        [:dynamic, string_literal(exp)]
      end
    end
  end
end
