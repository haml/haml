module Hamlit
  module Concerns
    module Escapable
      def self.included(base)
        base.define_options(escape_html: false)
      end

      def escape_html(exp, force_escape = false)
        [:escape, force_escape || @options[:escape_html], exp]
      end
    end
  end
end
