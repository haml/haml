require 'hamlit/concerns/escapable'
require 'hamlit/concerns/included'

module Hamlit
  module Compilers
    module Script
      extend Concerns::Included

      included do
        include Concerns::Escapable
      end

      def on_haml_script(*exps)
        exps     = exps.dup
        variable = result_identifier
        code     = exps.shift

        assign = [:code, "#{variable} = #{code}"]
        result = escape_html([:dynamic, variable])

        # FIXME: should not result be compiled?
        [:multi, assign, *exps.map { |exp| compile(exp) }, result]
      end

      private

      def result_identifier
        @id_auto_increment ||= -1
        @id_auto_increment += 1
        "_hamlit_compiler#{@id_auto_increment}"
      end
    end
  end
end
