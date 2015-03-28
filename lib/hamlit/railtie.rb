require 'temple'

module Hamlit
  RailsTemplate = Temple::Templates::Rails.create(
    Hamlit::Engine,
    generator:   Temple::Generators::RailsOutputBuffer,
    register_as: :haml,
    escape_html: true,
    streaming:   true,
    ugly:        true,
  )
end
