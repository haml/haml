require 'temple'
require 'hamlit/parser'

module Hamlit
  class Engine < Temple::Engine
    define_options generator: Temple::Generators::ArrayBuffer

    use Parser
    html :Fast
    use :Generator do
      options[:generator].new
    end
  end
end
