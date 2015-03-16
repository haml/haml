module Hamlit
  Template = Temple::Templates::Tilt.create(Hamlit::Engine, register_as: :haml)

  if defined?(::ActionView)
    RailsTemplate = Temple::Templates::Rails.create(
      Hamlit::Engine,
      generator:   Temple::Generators::RailsOutputBuffer,
      register_as: :haml,
      escape_html: true,
      streaming:   true,
    )
  end
end
