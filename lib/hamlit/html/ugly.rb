require 'hamlit/concerns/deprecation'
require 'temple/html/fast'

module Hamlit
  module HTML
    class Ugly < Temple::HTML::Fast
      include Concerns::Deprecation
    end
  end
end
