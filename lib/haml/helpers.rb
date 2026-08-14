# frozen_string_literal: true
module Haml
  module Helpers
    DEFAULT_PRESERVE_TAGS = %w[textarea pre code].freeze

    # The two callers differ only in how the preserved content is marked, which is what
    # the block is for; everything around it, the SafeBuffer workaround included, is here.
    #
    # @api private
    def self.find_and_preserve(input, tags)
      # An empty entry would add an alternative matching `<>`.
      pattern = tags.reject(&:empty?).map { |tag| Regexp.escape(tag) }.join('|')
      re = /<(#{pattern})([^>]*)>(.*?)(<\/\1>)/im
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
