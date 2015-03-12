require 'temple'
require 'hamlit/parser'

module Hamlit
  class Engine < Temple::Engine
    use Parser
    html :Fast
    generator :ArrayBuffer
  end
end
