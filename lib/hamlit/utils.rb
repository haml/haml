# frozen_string_literal: true
module Hamlit
  module Utils
    if /java/ === RUBY_PLATFORM # JRuby
      require 'cgi/escape'

      def self.escape_html(html)
        CGI.escapeHTML(html.to_s)
      end
    else
      require 'hamlit/hamlit' # Hamlit::Utils.escape_html
    end

    def self.escape_html_safe(html)
      html.html_safe? ? html : escape_html(html)
    end
  end
end
