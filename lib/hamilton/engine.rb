require 'temple'
require 'hamilton/parser'

module Hamilton
  class Engine < Temple::Engine
    use Parser
    html :Fast
    generator :ArrayBuffer
  end
end
