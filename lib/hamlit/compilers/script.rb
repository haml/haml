require 'hamlit/concerns/escapable'
require 'hamlit/concerns/included'

module Hamlit
  module Compilers
    module Script
      extend Concerns::Included

      included do
        include Concerns::Escapable
      end

      def on_haml_script(code, options, *exps)
        variable = result_identifier

        assign = [:code, "#{variable} = #{code}"]
        result = escape_html([:dynamic, variable], options[:force_escape])
        result = [:dynamic, variable] if options[:disable_escape]
        [:multi, assign, *exps.map { |exp| compile(exp) }, compile(result)]
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
