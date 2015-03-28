require 'hamlit/compilers/doctype'
require 'hamlit/compilers/preserve'
require 'hamlit/filter'

module Hamlit
  class Compiler < Hamlit::Filter
    include Compilers::Doctype
    include Compilers::Preserve
  end
end
