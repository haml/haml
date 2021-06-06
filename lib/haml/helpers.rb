# frozen_string_literal: true

require 'erb'

module Haml
  # This module contains various helpful methods to make it easier to do various tasks.
  # {Haml::Helpers} is automatically included in the context
  # that a Haml template is parsed in, so all these methods are at your
  # disposal from within the template.
  module Helpers
    self.extend self

    # Uses \{#preserve} to convert any newlines inside whitespace-sensitive tags
    # into the HTML entities for endlines.
    #
    # @param tags [Array<String>] Tags that should have newlines escaped
    #
    # @overload find_and_preserve(input, tags = haml_buffer.options[:preserve])
    #   Escapes newlines within a string.
    #
    #   @param input [String] The string within which to escape newlines
    # @overload find_and_preserve(tags = haml_buffer.options[:preserve])
    #   Escapes newlines within a block of Haml code.
    def self.find_and_preserve(input = nil, tags)
      tags = tags.map { |tag| Regexp.escape(tag) }.join('|')
      re = /<(#{tags})([^>]*)>(.*?)(<\/\1>)/im
      input.to_s.gsub(re) do |s|
        s =~ re # Can't rely on $1, etc. existing since Rails' SafeBuffer#gsub is incompatible
        "<#{$1}#{$2}>#{preserve($3)}</#{$1}>"
      end
    end

    # Takes any string, finds all the newlines, and converts them to
    # HTML entities so they'll render correctly in
    # whitespace-sensitive tags without screwing up the indentation.
    #
    # @overload preserve(input)
    #   Escapes newlines within a string.
    #
    #   @param input [String] The string within which to escape all newlines
    # @overload preserve
    #   Escapes newlines within a block of Haml code.
    def self.preserve(input = nil)
      s = input.to_s.chomp("\n")
      s.gsub!(/\n/, '&#x000A;')
      s.delete!("\r")
      s
    end

    # Characters that need to be escaped to HTML entities from user input
    HTML_ESCAPE = {'&' => '&amp;', '<' => '&lt;', '>' => '&gt;', '"' => '&quot;', "'" => '&#39;'}.freeze

    HTML_ESCAPE_REGEX = /['"><&]/

    # Returns a copy of `text` with ampersands, angle brackets and quotes
    # escaped into HTML entities.
    #
    # Note that if ActionView is loaded and XSS protection is enabled
    # (as is the default for Rails 3.0+, and optional for version 2.3.5+),
    # this won't escape text declared as "safe".
    #
    # @param text [String] The string to sanitize
    # @return [String] The sanitized string
    def html_escape(text)
      CGI.escapeHTML(text.to_s)
    end

    class << self
      # Always escape text regardless of html_safe?
      alias_method :html_escape_without_haml_xss, :html_escape
    end

    HTML_ESCAPE_ONCE_REGEX = /['"><]|&(?!(?:[a-zA-Z]+|#(?:\d+|[xX][0-9a-fA-F]+));)/

    # Escapes HTML entities in `text`, but without escaping an ampersand
    # that is already part of an escaped entity.
    #
    # @param text [String] The string to sanitize
    # @return [String] The sanitized string
    def self.escape_once(text)
      text = text.to_s
      text.gsub(HTML_ESCAPE_ONCE_REGEX, HTML_ESCAPE)
    end

    private

    # The current {Haml::Buffer} object.
    #
    # @return [Haml::Buffer]
    def haml_buffer
      @haml_buffer if defined? @haml_buffer
    end
  end
end
