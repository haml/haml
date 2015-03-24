require 'temple/html/fast'

module Hamlit
  class HTML < Temple::HTML::Fast
    define_options :format

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

    def normalize_format(format)
      return :html unless format

      case format
      when :html4, :html5
        :html
      else
        format
      end
    end
  end
end
