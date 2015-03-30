require 'hamlit/concerns/string_literal'

# FIXME: This compiler has an extremely bad effect for performance.
# We should optimize this.
module Hamlit
  module Compilers
    module Text
      include Concerns::StringLiteral

      def on_haml_text(exp)
        [:dynamic, string_literal(exp)]
      end
    end
  end
end
