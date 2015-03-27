require 'temple/html/pretty'

module Hamlit
  module HTML
    class Pretty < Temple::HTML::Pretty
      DEPCATED_OPTIONS = %i[html4 html5].freeze

      define_options :format

      def initialize(opts = {})
        super rewrite_deprecated_options(opts)
      end

      def on_static(exp)
        if exp == "\n"
          [:static, '']
        else
          [:static, exp]
        end
      end

      private

      # Temple's warning is noisy in haml-spec.
      def rewrite_deprecated_options(options)
        options = options.dup
        options[:format] = :html if DEPCATED_OPTIONS.include?(options[:format])
        options
      end
    end
  end
end
