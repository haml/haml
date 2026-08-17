# frozen_string_literal: true
module Haml
  # find_and_preserve, shared by compiled templates and RailsHelpers.
  #
  # @api private
  module Preserver
    DEFAULT_TAGS = %w[textarea pre code].freeze

    def self.build_regex(tags)
      # An empty entry would add an alternative matching `<>`.
      pattern = tags.reject(&:empty?).map { |tag| Regexp.escape(tag) }.join('|')
      /<(#{pattern})([^>]*)>(.*?)(<\/\1>)/im
    end
    private_class_method :build_regex

    DEFAULT_REGEX = build_regex(DEFAULT_TAGS)
    private_constant :DEFAULT_REGEX

    # Past this many lists the merge below turns quadratic, so the cache starts over.
    MAX_REGEXES = 64
    private_constant :MAX_REGEXES

    INITIAL_REGEXES = { DEFAULT_TAGS => DEFAULT_REGEX }.freeze
    private_constant :INITIAL_REGEXES

    @regexes = INITIAL_REGEXES

    # The cache is replaced, never mutated, so a racing writer at worst rebuilds a regex.
    def self.regex(tags)
      return DEFAULT_REGEX if tags.equal?(DEFAULT_TAGS)

      cache = @regexes
      cache[tags] || begin
        regex = build_regex(tags)
        # Copied so a caller mutating its own list, or a String in it, cannot strand the entry.
        key = tags.map { |tag| tag.dup.freeze }.freeze
        cache = INITIAL_REGEXES if cache.size >= MAX_REGEXES
        @regexes = cache.merge(key => regex).freeze
        regex
      end
    end

    def self.find_and_preserve(input, tags)
      re = regex(tags)
      input.to_s.gsub(re) do |s|
        s =~ re # Can't rely on $1, etc. existing since Rails' SafeBuffer#gsub is incompatible
        name, attributes, content = $1, $2, $3
        "<#{name}#{attributes}>#{yield(content)}</#{name}>"
      end
    end
  end
end
