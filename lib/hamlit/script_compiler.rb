require 'temple/filter'

module Hamlit
  class ScriptCompiler < Temple::Filter
    def on_haml_script(*exps)
      exps     = exps.dup
      variable = result_identifier
      code     = exps.shift

      assign = [:code, "#{variable} = #{code}"]
      result = [:dynamic, variable]
      [:multi, assign, *exps, result]
    end

    private

    def result_identifier
      @id_auto_increment ||= -1
      @id_auto_increment += 1
      "_hamlit_compiler#{@id_auto_increment}"
    end
  end
end
