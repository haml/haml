# frozen_string_literal: true
module Haml
  module Helpers
    # Referenced by name from the emitted Ruby, so every render hands preserve_regex the
    # same object.
    DEFAULT_PRESERVE_TAGS = %w[textarea pre code].freeze

    def self.build_preserve_regex(tags)
      # An empty entry would add an alternative matching `<>`.
      pattern = tags.reject(&:empty?).map { |tag| Regexp.escape(tag) }.join('|')
      /<(#{pattern})([^>]*)>(.*?)(<\/\1>)/im
    end
    private_class_method :build_preserve_regex

    DEFAULT_PRESERVE_REGEX = build_preserve_regex(DEFAULT_PRESERVE_TAGS)
    private_constant :DEFAULT_PRESERVE_REGEX

    # Past this many lists the copy below turns quadratic, so the cache starts over rather
    # than leaving every later list uncached for the life of the process.
    MAX_PRESERVE_REGEXES = 64
    private_constant :MAX_PRESERVE_REGEXES

    INITIAL_PRESERVE_REGEXES = { DEFAULT_PRESERVE_TAGS => DEFAULT_PRESERVE_REGEX }.freeze
    private_constant :INITIAL_PRESERVE_REGEXES

    @preserve_regexes = INITIAL_PRESERVE_REGEXES

    # Building this regex costs far more than matching with it. The cache is replaced,
    # never mutated, so a racing writer at worst rebuilds a regex.
    #
    # @api private
    def self.preserve_regex(tags)
      return DEFAULT_PRESERVE_REGEX if tags.equal?(DEFAULT_PRESERVE_TAGS)

      cache = @preserve_regexes
      cache[tags] || begin
        regex = build_preserve_regex(tags)
        # Keyed by a copy: a rebuilt %w[...] literal still hits, and a caller mutating its
        # own list, or a String in it, cannot strand the entry.
        key = tags.map { |tag| tag.dup.freeze }.freeze
        cache = INITIAL_PRESERVE_REGEXES if cache.size >= MAX_PRESERVE_REGEXES
        @preserve_regexes = cache.merge(key => regex).freeze
        regex
      end
    end

    # The two callers differ only in how the preserved content is marked, which is what
    # the block is for; everything around it, the SafeBuffer workaround included, is here.
    #
    # @api private
    def self.find_and_preserve(input, tags)
      re = preserve_regex(tags)
      input.to_s.gsub(re) do |s|
        s =~ re # Can't rely on $1, etc. existing since Rails' SafeBuffer#gsub is incompatible
        name, attributes, content = $1, $2, $3
        content = block_given? ? yield(content) : preserve(content)
        "<#{name}#{attributes}>#{content}</#{name}>"
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
