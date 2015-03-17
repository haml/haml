require 'temple/html/filter'

# Hamlit::Filter calls `compile` in the hamlit's original ASTs.
module Hamlit
  class Filter < Temple::HTML::Filter
    def on_haml_filter(name, exp)
      [:haml, :filter, name, compile(exp)]
    end

    def on_haml_attrs(*exps)
      [:haml, :attrs, *exps.map { |e| compile(e) }]
    end

    def on_haml_script(*exps)
      [:haml, :script, *exps.map { |e| compile(e) }]
    end

    def on_haml_text(exp)
      [:haml, :text, compile(exp)]
    end
  end
end
