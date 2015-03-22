require 'temple/html/fast'
require 'hamlit/filter'

module Hamlit
  class HTML < Temple::HTML::Fast
    def initialize(opts = {})
      super rewrite_format(opts)
    end

    private

    # Temple's warning is noisy.
    def rewrite_format(options)
      options = options.dup

      case options[:format]
      when :html4, :html5
        options[:format] = :html
      end

      options
    end
  end
end
