require 'hamlit/concerns/included'

module Hamlit
  module Concerns
    module Escapable
      extend Included

      included do
        define_options escape_html: false
      end

      def escape_html(exp, force_escape = false)
        [:escape, force_escape || @options[:escape_html], exp]
      end
    end
  end
end
