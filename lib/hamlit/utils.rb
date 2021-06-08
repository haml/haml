# frozen_string_literal: true
module Hamlit
  module Utils
    # Java extension is not implemented for JRuby yet.
    # TruffleRuby does not implement `rb_ary_sort_bang`, etc.
    if /java/ === RUBY_PLATFORM || RUBY_ENGINE == 'truffleruby'
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
