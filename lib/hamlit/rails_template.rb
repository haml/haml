require 'temple'
require 'hamlit/engine'
require 'hamlit/rails_helpers'
require 'hamlit/parser/haml_helpers'
require 'hamlit/parser/haml_util'

module Hamlit
  RailsTemplate = Temple::Templates::Rails.create(
    Hamlit::Engine,
    generator:     Temple::Generators::RailsOutputBuffer,
    register_as:   :haml,
    use_html_safe: true,
    streaming:     true,
  )

  # https://github.com/haml/haml/blob/4.0.7/lib/haml/template.rb
  module HamlHelpers
    require 'hamlit/parser/haml_xss_mods'
    include Hamlit::HamlHelpers::XssMods
  end

  module HamlUtil
    undef :rails_xss_safe? if defined? rails_xss_safe?
    def rails_xss_safe?; true; end
  end
end

# Haml extends Haml::Helpers in ActionView each time.
# It costs much, so Hamlit includes a compatible module at first.
ActionView::Base.send :include, Hamlit::RailsHelpers
