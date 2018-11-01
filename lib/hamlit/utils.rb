# frozen_string_literal: true
unless /java/ === RUBY_PLATFORM # exclude JRuby
  require 'hamlit/hamlit' # depends on C-ext defines Hamlit::Utils first for now
end

module Hamlit
  module Utils
    def self.escape_html_safe(html)
      html.html_safe? ? html : escape_html(html)
    end
  end
end
