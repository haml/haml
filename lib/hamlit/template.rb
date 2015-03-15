module Hamlit
  Template = Temple::Templates::Tilt.create(Hamlit::Engine, register_as: :haml)

  if defined?(::ActionView)
    RailsTemplate = Temple::Templates::Rails.create(
      Hamlit::Engine,
      register_as: :haml,
      # Use rails-specific generator. This is necessary
      # to support block capturing and streaming.
      generator: Temple::Generators::RailsOutputBuffer,
      escape_html: true,
      streaming: true,
    )
  end
end
