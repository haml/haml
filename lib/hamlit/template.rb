require 'temple'
require 'hamlit/engine'

# Load tilt/haml first to override if available
begin
  require 'haml'
rescue LoadError
else
  require 'tilt/haml'
end

module Hamlit
  Template = Temple::Templates::Tilt.create(
    Hamlit::Engine,
    register_as: :haml,
  )
end
