require 'hamlit/compilers/doctype'
require 'hamlit/compilers/preserve'
require 'hamlit/compilers/script'
require 'hamlit/concerns/escapable'
require 'hamlit/filter'

module Hamlit
  class Compiler < Hamlit::Filter
    include Compilers::Doctype
    include Compilers::Preserve
    include Compilers::Script
    include Concerns::Escapable
  end
end
