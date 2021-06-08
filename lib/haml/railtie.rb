# frozen_string_literal: true
require 'rails'

module Haml
  class Railtie < ::Rails::Railtie
    initializer :haml, before: :load_config_initializers do |app|
      # Load haml/plugin first to override if available
      begin
        require 'haml/plugin'
      rescue LoadError
      end
      require 'haml/rails_template'
    end
  end
end
