require 'action_pack'
require 'action_controller'
require 'action_view'

if ActionPack::VERSION::MAJOR >= 3
  # Necessary for Rails 3
  require 'rails'
else
  # Necessary for Rails 2.3.*
  require 'initializer'
end

if defined?(Rails::Application) # Rails 3
  class TestApp < Rails::Application
    config.root = File.join(File.dirname(__FILE__), "../..")
  end
  Rails.application = TestApp
elsif defined?(RAILS_ROOT)
  RAILS_ROOT.replace(File.join(File.dirname(__FILE__), "../.."))
else
  RAILS_ROOT = File.join(File.dirname(__FILE__), "../..")
end

ActionController::Base.logger = Logger.new(nil)