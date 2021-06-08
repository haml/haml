# frozen_string_literal: true
require 'temple'
require 'haml/engine'
require 'haml/rails_helpers'
require 'haml/parser/haml_helpers'
require 'haml/parser/haml_util'

module Haml
  class RailsTemplate
    # Compatible with: https://github.com/judofyr/temple/blob/v0.7.7/lib/temple/mixins/options.rb#L15-L24
    class << self
      def options
        @options ||= {
          generator:     Temple::Generators::RailsOutputBuffer,
          use_html_safe: true,
          streaming:     true,
          buffer_class:  'ActionView::OutputBuffer',
        }
      end

      def set_options(opts)
        options.update(opts)
      end
    end

    def call(template, source = nil)
      source ||= template.source
      options = RailsTemplate.options

      # https://github.com/haml/haml/blob/4.0.7/lib/haml/template/plugin.rb#L19-L20
      # https://github.com/haml/haml/blob/4.0.7/lib/haml/options.rb#L228
      if template.respond_to?(:type) && template.type == 'text/xml'
        options = options.merge(format: :xhtml)
      end

      if ActionView::Base.try(:annotate_rendered_view_with_filenames) && template.format == :html
        options[:preamble] = "<!-- BEGIN #{template.short_identifier} -->\n"
        options[:postamble] = "<!-- END #{template.short_identifier} -->\n"
      end

      Engine.new(options).call(source)
    end

    def supports_streaming?
      RailsTemplate.options[:streaming]
    end
  end
  ActionView::Template.register_template_handler(:haml, RailsTemplate.new)

  # https://github.com/haml/haml/blob/4.0.7/lib/haml/template.rb
  module HamlHelpers
    require 'haml/parser/haml_helpers/xss_mods'
    include Haml::HamlHelpers::XssMods
  end

  module HamlUtil
    undef :rails_xss_safe? if defined? rails_xss_safe?
    def rails_xss_safe?; true; end
  end
end

# Haml extends Haml::Helpers in ActionView each time.
# It costs much, so Haml includes a compatible module at first.
ActionView::Base.send :include, Haml::RailsHelpers
