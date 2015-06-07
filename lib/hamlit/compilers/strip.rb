require 'hamlit/concerns/whitespace'

# This module is created to compile [:haml, :strip],
# which is sexp for whitespace inner removal.module Hamlit
module Hamlit
  module Compilers
    module Strip
      include Concerns::Whitespace

      def on_haml_strip(*exps)
        exps = exps.dup
        remove_first_space!(exps)
        remove_last_space!(exps)

        on_multi(*exps)
      end
    end
  end
end
