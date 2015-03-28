require 'hamlit/engine'
require 'hamlit/template'
require 'hamlit/version'

begin
  require 'rails'
  require 'hamlit/railtie'
rescue LoadError
end
