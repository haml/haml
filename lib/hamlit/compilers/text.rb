require 'hamlit/concerns/string_interpolation'

module Hamlit
  module Compilers
    module Text
      include Concerns::StringInterpolation

      def on_haml_text(exp)
        return [:static, exp] unless contains_interpolation?(exp)

        [:dynamic, string_literal(exp)]
      end
    end
  end
end
