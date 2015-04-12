module Hamlit
  module Compilers
    module Script
      def on_haml_script(code, options, *exps)
        variable = result_identifier

        assign = [:code, "#{variable} = #{code}"]
        result = [:escape, true, [:dynamic, variable]]
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
