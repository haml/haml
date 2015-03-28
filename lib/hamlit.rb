require 'hamlit/engine'
require 'hamlit/helpers'
require 'hamlit/template'
require 'hamlit/version'

begin
  require 'rails'
  require 'hamlit/rails_template'
rescue LoadError
end
