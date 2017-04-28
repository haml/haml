# frozen_string_literal: true
require 'haml/template/options'

# check for a compatible Rails version when Haml is loaded
if (activesupport_spec = Gem.loaded_specs['activesupport'])
  if activesupport_spec.version.to_s < '3.2'
    raise Exception.new("\n\n** Haml now requires Rails 3.2 and later. Use Haml version 4.0.4\n\n")
  end
end

module Haml
  module Filters
    module RailsErb
      extend Plain
      extend TiltFilter
      extend PrecompiledTiltFilter
    end
  end

  class Railtie < ::Rails::Railtie
    initializer :haml do |app|
      ActiveSupport.on_load(:action_view) do
        require "haml/template"

        if defined?(::Sass::Rails::SassTemplate) && app.config.assets.enabled
          require "haml/sass_rails_filter"
        end

        if defined? Erubi
          require "haml/helpers/safe_erubi_template"
          Haml::Filters::RailsErb.template_class = Haml::SafeErubiTemplate
        else
          require "haml/helpers/safe_erubis_template"
          Haml::Filters::RailsErb.template_class = Haml::SafeErubisTemplate
        end
        Haml::Template.options[:filters] = { 'erb' => Haml::Filters::RailsErb }
      end
    end
  end
end
