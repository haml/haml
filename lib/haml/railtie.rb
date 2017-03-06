require 'haml/template/options'

module Haml
  class Railtie < ::Rails::Railtie
    initializer :haml do |app|

      ActiveSupport.on_load(:action_view) do
        require "haml/template"

        if defined?(::Sass::Rails::SassTemplate) && app.config.assets.enabled
          require "haml/sass_rails_filter"
        end

        require "haml/helpers/safe_erubis_template"
        Haml::Filters::Erb.template_class = Haml::SafeErubisTemplate
      end
    end
  end
end
