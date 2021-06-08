# frozen_string_literal: true

require 'erb'

module Haml
  module Helpers
    # Uses \{#preserve} to convert any newlines inside whitespace-sensitive tags
    # into the HTML entities for endlines.
    #
    # @param tags [Array<String>] Tags that should have newlines escaped
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
    def self.html_escape(text)
      CGI.escapeHTML(text.to_s)
    end

    def self.html_escape_safe(text)
      text.html_safe? ? text : html_escape(text.to_s)
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

    def self.escape_once_safe(text)
      text.html_safe? ? text : escape_once(text)
    end

    # Works like #{find_and_preserve}, but allows the first newline after a
    # preserved opening tag to remain unencoded, and then outdents the content.
    # This change was motivated primarily by the change in Rails 3.2.3 to emit
    # a newline after textarea helpers.
    #
    # @param input [String] The text to process
    # @since Haml 4.0.1
    # @private
    def self.fix_textareas!(input)
      return input unless input.include?('<textarea'.freeze)

      pattern = /<(textarea)([^>]*)>(\n|&#x000A;)(.*?)<\/textarea>/im
      input.gsub!(pattern) do |s|
        match = pattern.match(s)
        content = match[4]
        if match[3] == '&#x000A;'
          content.sub!(/\A /, '&#x0020;')
        else
          content.sub!(/\A[ ]*/, '')
        end
        "<#{match[1]}#{match[2]}>\n#{content}</#{match[1]}>"
      end
      input
    end
  end
end
