# frozen_string_literal: true
require 'rails'

module Hamlit
  class Railtie < ::Rails::Railtie
    initializer :hamlit, before: :load_config_initializers do |app|
      require 'hamlit/rails_template'
    end
  end
end
