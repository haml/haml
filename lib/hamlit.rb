require 'hamlit/engine'
require 'hamlit/template'
require 'hamlit/version'

begin
  require 'hamlit/railtie'
rescue LoadError
end
