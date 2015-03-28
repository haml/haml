require 'hamlit/compilers/preserve'
require 'hamlit/filter'

module Hamlit
  class Compiler < Hamlit::Filter
    include Compilers::Preserve
  end
end
