if defined?(ActiveSupport)
  # check for a compatible Rails version when Haml is loaded
  if (activesupport_spec = Gem.loaded_specs['activesupport'])
    if activesupport_spec.version.to_s < '3.2'
      raise Exception.new("\n\n** Haml now requires Rails 3.2 and later. Use Haml version 4.0.4\n\n")
    end
  end

  require 'haml/template/options'
  ActiveSupport.on_load(:before_initialize) do
    ActiveSupport.on_load(:action_view) do
      require "hamlit/template"
    end
  end
end

module Hamlit
  class Railtie < ::Rails::Railtie
    initializer :hamlit do |app|
      require 'hamlit/template'
    end
  end
end
