# frozen_string_literal: true
module Haml
  module Helpers
    # Referenced by name from the Ruby the compiler emits, so `~` does not rebuild the list
    # per render, and the default of RailsHelpers#find_and_preserve, so both paths hand
    # preserve_regex the same object.
    DEFAULT_PRESERVE_TAGS = %w[textarea pre code].freeze

    def self.build_preserve_regex(tags)
      pattern = tags.map { |tag| Regexp.escape(tag) }.join('|')
      /<(#{pattern})([^>]*)>(.*?)(<\/\1>)/im
    end
    private_class_method :build_preserve_regex

    DEFAULT_PRESERVE_REGEX = build_preserve_regex(DEFAULT_PRESERVE_TAGS)
    private_constant :DEFAULT_PRESERVE_REGEX

    # Past this many distinct tag lists we stop caching and pay what find_and_preserve paid
    # before, rather than letting a caller that derives tags from its input grow the cache
    # without bound -- the copy below makes that quadratic.
    MAX_PRESERVE_REGEXES = 64
    private_constant :MAX_PRESERVE_REGEXES

    @preserve_regexes = { DEFAULT_PRESERVE_TAGS => DEFAULT_PRESERVE_REGEX }.freeze

    # Building this regex costs far more than matching with it, and a template renders with
    # the same tags every time. The cache is replaced, never mutated in place, so a reader
    # only ever sees a frozen Hash and needs no lock on JRuby or TruffleRuby either; the
    # worst a racing writer can do is rebuild a regex another thread already built.
    #
    # @api private
    def self.preserve_regex(tags)
      return DEFAULT_PRESERVE_REGEX if tags.equal?(DEFAULT_PRESERVE_TAGS)

      cache = @preserve_regexes
      cache[tags] || begin
        regex = build_preserve_regex(tags)
        if cache.size < MAX_PRESERVE_REGEXES
          # Keyed by content, so a %w[...] literal rebuilt per call still hits; dup (not map)
          # keeps a caller that mutates its own list from stranding the entry, without
          # forcing the key to an Array.
          @preserve_regexes = cache.merge(tags.dup.freeze => regex).freeze
        end
        regex
      end
    end

    def self.preserve(input)
      s = input.to_s.chomp("\n")
      s.gsub!("\n", '&#x000A;')
      s.delete!("\r")
      s
    end

    def preserve(input)
      Helpers.preserve(input)
    end
  end
end
