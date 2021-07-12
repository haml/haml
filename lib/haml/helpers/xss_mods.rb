# frozen_string_literal: true

module Haml
  module Helpers
    # This module overrides Haml helpers to work properly
    # in the context of ActionView.
    # Currently it's only used for modifying the helpers
    # to work with Rails' XSS protection methods.
    module XssMods
      def self.included(base)
        # Those two always have _without_haml_xss
        %w[html_escape].each do |name|
          base.send(:alias_method, name, "#{name}_with_haml_xss")
        end
      end

      # Don't escape text that's already safe,
      # output is always HTML safe
      def html_escape_with_haml_xss(text)
        str = text.to_s
        return text if str.html_safe?
        Haml::Util.html_safe(Haml::Helpers.html_escape_without_haml_xss(str))
      end

      private

      # Escapes the HTML in the text if and only if
      # Rails XSS protection is enabled *and* the `:escape_html` option is set.
      def haml_xss_html_escape(text)
        return text unless Haml::Util.rails_xss_safe? && haml_buffer.options[:escape_html]
        Haml::Helpers.html_escape(text)
      end
    end

    class ErrorReturn
      # Any attempt to treat ErrorReturn as a string should cause it to blow up.
      alias_method :html_safe, :to_s
      alias_method :html_safe?, :to_s
      alias_method :html_safe!, :to_s
    end
  end
end
