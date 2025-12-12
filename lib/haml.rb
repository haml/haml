# frozen_string_literal: true
require 'haml/engine'
require 'haml/error'
require 'haml/version'
require 'haml/template'

if File.basename($0) != 'haml'
  require 'haml/railtie' if defined?(Rails::Railtie)
end
