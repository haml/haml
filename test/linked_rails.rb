require 'action_pack'
require 'action_controller'
require 'action_view'

begin
  require 'rails'
  class TestApp < Rails::Application
    config.root = ""
  end
  Rails.application = TestApp

# For Rails 2.x
rescue LoadError
  require 'initializer'
  RAILS_ROOT = ""
end

ActionController::Base.logger = Logger.new(nil)