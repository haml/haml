require 'temple/html/fast'
require 'hamlit/concerns/format_normalizable'

module Hamlit
  class HTML < Temple::HTML::Fast
    include Concerns::FormatNormalizable

    def initialize(opts = {})
      super rewrite_format(opts)
    end

    private

    # Temple's warning is noisy.
    def rewrite_format(options)
      options = options.dup
      options[:format] = normalize_format(options[:format]) if options[:format]
      options
    end
  end
end
