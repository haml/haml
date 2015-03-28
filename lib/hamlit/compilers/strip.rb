require 'hamlit/concerns/strippable'

module Hamlit
  module Compilers
    module Strip
      include Concerns::Strippable

      def on_haml_strip(*exps)
        stripped = strip_newline(exps)
        on_multi(*stripped)
      end
    end
  end
end
