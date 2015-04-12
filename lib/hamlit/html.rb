require 'hamlit/concerns/deprecation'
require 'temple/html/fast'

# This is created to be compatible with Haml's ugly mode.
# Currently pretty mode is not supported.
module Hamlit
  class HTML < Temple::HTML::Fast
    include Concerns::Deprecation
  end
end
