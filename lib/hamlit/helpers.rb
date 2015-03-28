# This is a module compatible with Haml::Helpers.
# It is included by ActionView in initializer.
module Hamlit
  module Helpers
    extend self

    DEFAULT_PRESERVE_TAGS = %w[textarea pre code].freeze

    def find_and_preserve(input = nil, tags = DEFAULT_PRESERVE_TAGS, &block)
      return find_and_preserve(capture_haml(&block), input || tags) if block

      tags = tags.each_with_object('') do |t, s|
        s << '|' unless s.empty?
        s << Regexp.escape(t)
      end

      re = /<(#{tags})([^>]*)>(.*?)(<\/\1>)/im
      input.to_s.gsub(re) do |s|
        s =~ re # Can't rely on $1, etc. existing since Rails' SafeBuffer#gsub is incompatible
        "<#{$1}#{$2}>#{preserve($3)}</#{$1}>"
      end
    end

    def preserve(input = nil, &block)
      return preserve(capture_haml(&block)) if block
      s = input.to_s.chomp("\n")
      s.gsub!(/\n/, '&#x000A;')
      s.delete!("\r")
      s
    end

    def capture_haml(*args, &block)
      raise NotImplementedError
    end
  end
end
