require 'temple'
require 'hamlit/attribute_filter'
require 'hamlit/parser'

module Hamlit
  class Engine < Temple::Engine
    define_options generator: Temple::Generators::ArrayBuffer

    use Parser
    use AttributeFilter
    html :Fast
    use :Generator do
      options[:generator].new
    end
  end
end
