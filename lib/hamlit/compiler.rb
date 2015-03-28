require 'hamlit/compilers/doctype'
require 'hamlit/compilers/dynamic'
require 'hamlit/compilers/filter'
require 'hamlit/compilers/preserve'
require 'hamlit/compilers/script'
require 'hamlit/compilers/text'
require 'hamlit/concerns/escapable'
require 'hamlit/concerns/registerable'
require 'hamlit/filter'
require 'hamlit/filters/css'
require 'hamlit/filters/javascript'
require 'hamlit/filters/ruby'

module Hamlit
  class Compiler < Hamlit::Filter
    include Compilers::Doctype
    include Compilers::Dynamic
    include Compilers::Filter
    include Compilers::Preserve
    include Compilers::Script
    include Compilers::Text
    include Concerns::Escapable
    extend  Concerns::Registerable

    register :javascript, Filters::Javascript
    register :css,        Filters::Css
    register :ruby,       Filters::Ruby
  end
end
