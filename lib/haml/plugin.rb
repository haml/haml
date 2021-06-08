# frozen_string_literal: true

module Haml

  # This module makes Haml work with Rails using the template handler API.
  class Plugin
    def handles_encoding?; true; end

    def compile(template, source)
      options = Haml::Template.options.dup
      if template.respond_to?(:type)
        options[:mime_type] = template.type
      elsif template.respond_to? :mime_type
        options[:mime_type] = template.mime_type
      end
      options[:filename] = template.identifier
      options.merge!(
        use_html_safe: true,
        generator: Temple::Generators::RailsOutputBuffer,
        buffer_class: 'ActionView::OutputBuffer',
      )
      Haml::Engine.new(source, options).compiler.precompiled
    end

    def self.call(template, source = nil)
      source ||= template.source

      new.compile(template, source)
    end
  end
end

ActionView::Template.register_template_handler(:haml, Haml::Plugin)
