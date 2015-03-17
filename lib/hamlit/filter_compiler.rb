require 'hamlit/filter'
require 'hamlit/concerns/registerable'
require 'hamlit/filters/css'
require 'hamlit/filters/javascript'
require 'hamlit/filters/ruby'

module Hamlit
  class FilterCompiler < Hamlit::Filter
    extend Concerns::Registerable

    register :javascript, Filters::Javascript
    register :css,        Filters::Css
    register :ruby,       Filters::Ruby

    def on_haml_filter(name, exp)
      compiler = FilterCompiler.find(name)
      compiler.compile(exp)
    end
  end
end
