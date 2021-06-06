# frozen_string_literal: true

require 'haml/template/options'

# check for a compatible Rails version when Haml is loaded
if (activesupport_spec = Gem.loaded_specs['activesupport'])
  if activesupport_spec.version.to_s < '4.0'
    raise Exception.new("\n\n** Haml now requires Rails 4.0 and later. Use Haml version 4.0.x\n\n")
  end
end

module Haml
  class Railtie < ::Rails::Railtie
    initializer :haml do |app|
      ActiveSupport.on_load(:action_view) do
        require "haml/template"
      end
    end
  end
end
