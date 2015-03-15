module Hamlit
  module Concerns
    module Escapable
      def self.included(base)
        base.define_options(escape_html: false)
      end

      def escape_html(exp)
        [:escape, @options[:escape_html], exp]
      end
    end
  end
end
