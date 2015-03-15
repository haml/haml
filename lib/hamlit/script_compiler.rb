require 'temple/html/filter'
require 'hamlit/concerns/escapable'

module Hamlit
  class ScriptCompiler < Temple::HTML::Filter
    include Concerns::Escapable

    def on_haml_script(*exps)
      exps     = exps.dup
      variable = result_identifier
      code     = exps.shift

      assign = [:code, "#{variable} = #{code}"]
      result = escape_html([:dynamic, variable])
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
