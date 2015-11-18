require 'temple'
require 'hamlit/engine'
require 'hamlit/rails_helpers'

module Hamlit
  RailsTemplate = Temple::Templates::Rails.create(
    Hamlit::Engine,
    generator:   Temple::Generators::RailsOutputBuffer,
    register_as: :haml,
    escape_html: true,
    streaming:   true,
  )
end

# Haml extends Haml::Helpers in ActionView each time.
# It costs much, so Hamlit includes a compatible module at first.
ActionView::Base.send :include, Hamlit::RailsHelpers
