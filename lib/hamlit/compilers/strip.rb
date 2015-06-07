require 'hamlit/parsers/whitespace'

# This module is created to compile [:haml, :strip],
# which is sexp for whitespace inner removal.module Hamlit
module Hamlit
  module Compilers
    module Strip
      include Parsers::Whitespace
      def on_haml_strip(*exps)
        exps = exps.dup
        remove_first_outer_space!(exps)
        remove_last_outer_space!(exps)
        on_multi(*exps)
      end
    end
  end
end
