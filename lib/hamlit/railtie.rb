# frozen_string_literal: true
require 'rails'

module Hamlit
  class Railtie < ::Rails::Railtie
    initializer :hamlit, before: :load_config_initializers do |app|
      # Load haml/plugin first to override if available
      begin
        require 'haml/plugin'
      rescue LoadError
      end
      require 'hamlit/rails_template'
    end
  end
end
