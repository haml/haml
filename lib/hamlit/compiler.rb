require 'hamlit/compilers/attributes'
require 'hamlit/compilers/doctype'
require 'hamlit/compilers/dynamic'
require 'hamlit/compilers/filter'
require 'hamlit/compilers/new_attribute'
require 'hamlit/compilers/preserve'
require 'hamlit/compilers/script'
require 'hamlit/compilers/text'
require 'hamlit/filter'

module Hamlit
  class Compiler < Hamlit::Filter
    include Compilers::Attributes
    include Compilers::Doctype
    include Compilers::Dynamic
    include Compilers::Filter
    include Compilers::NewAttribute
    include Compilers::Preserve
    include Compilers::Script
    include Compilers::Text
  end
end
