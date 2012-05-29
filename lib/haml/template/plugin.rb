# This file makes Haml work with Rails
# using the > 2.0.1 template handler API.

module Haml
  # In Rails 3.1+, template handlers don't inherit from anything. In <= 3.0, they do.
  # To avoid messy logic figuring this out, we just inherit from whatever the ERB handler does.
  class Plugin < Haml::Util.av_template_class(:Handlers)::ERB.superclass
    if ((defined?(ActionView::TemplateHandlers) &&
          defined?(ActionView::TemplateHandlers::Compilable)) ||
        (defined?(ActionView::Template) &&
          defined?(ActionView::Template::Handlers) &&
          defined?(ActionView::Template::Handlers::Compilable))) &&
        # In Rails 3.1+, we don't need to include Compilable.
        Haml::Util.av_template_class(:Handlers)::ERB.include?(
          Haml::Util.av_template_class(:Handlers)::Compilable)
      include Haml::Util.av_template_class(:Handlers)::Compilable
    end

    def handles_encoding?; true; end

    def compile(template)
      options = Haml::Template.options.dup
      options[:mime_type] = template.mime_type if template.respond_to? :mime_type
      options[:filename] = template.identifier
      Haml::Engine.new(template.source, options).send(:precompiled_with_ambles, [])
    end

    # In Rails 3.1+, #call takes the place of #compile
    def self.call(template)
      new.compile(template)
    end

    def cache_fragment(block, name = {}, options = nil)
      @view.fragment_for(block, name, options) do
        eval("_hamlout.buffer", block.binding)
      end
    end
  end
end

if defined? ActionView::Template and ActionView::Template.respond_to? :register_template_handler
  ActionView::Template
else
  ActionView::Base
end.register_template_handler(:haml, Haml::Plugin)