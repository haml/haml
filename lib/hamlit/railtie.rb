require 'rails'
require 'temple'

module Hamlit
  class Railtie < ::Rails::Railtie
    initializer :hamlit do |app|
      Hamlit::RailsTemplate = Temple::Templates::Rails.create(
        Hamlit::Engine,
        generator:   Temple::Generators::RailsOutputBuffer,
        register_as: :haml,
        escape_html: true,
        streaming:   true,
      )

      # Haml extends Haml::Helpers in ActionView each time.
      # It costs much, so Hamlit includes a compatible module at first.
      ActionView::Base.send :include, Hamlit::Helpers
    end
  end
end
