require 'temple/html/filter'
require 'hamlit/concerns/registerable'
require 'hamlit/filters/javascript'

module Hamlit
  class FilterCompiler < Temple::HTML::Filter
    extend Concerns::Registerable

    register :javascript, Filters::Javascript

    def on_haml_filter(name, lines)
      compiler = FilterCompiler.find(name)
      compiler.compile(lines)
    end
  end
end
