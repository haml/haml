# A module to suppress deprecation warnings by temple.
# These deprecated options are specified in haml-spec.
module Hamlit
  module Concerns
    module Deprecation
      DEPCATED_OPTIONS = %i[html4 html5].freeze

      def initialize(opts = {})
        super rewrite_deprecated_options(opts)
      end

      # Temple's warning is noisy in haml-spec.
      def rewrite_deprecated_options(options)
        options = options.dup
        options[:format] = :html if DEPCATED_OPTIONS.include?(options[:format])
        options
      end
    end
  end
end
