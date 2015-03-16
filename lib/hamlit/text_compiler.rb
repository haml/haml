require 'temple/html/filter'

module Hamlit
  class TextCompiler < Temple::HTML::Filter
    def on_haml_text(exp)
      [:static, exp]
    end
  end
end
