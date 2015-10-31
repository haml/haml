require 'hamlit/attribute_builder'
require 'hamlit/engine'
require 'hamlit/error'
require 'hamlit/hash_parser'
require 'hamlit/version'

begin
  require 'rails'
  require 'hamlit/railtie'
rescue LoadError
end
