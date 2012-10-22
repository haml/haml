module Haml

  # This module makes Haml work with Rails using the template handler API.
  class Plugin < ActionView::Template::Handlers::ERB.superclass

    # Rails 3.1+, template handlers don't inherit from anything. In <= 3.0, they
    # do. To avoid messy logic figuring this out, we just inherit from whatever
    # the ERB handler does.

    # In Rails 3.1+, we don't need to include Compilable.
    if (ActionPack::VERSION::MAJOR == 3) && (ActionPack::VERSION::MINOR < 1)
      include ActionView::Template::Handlers::Compilable
    end

    def handles_encoding?; true; end

    def compile(template)
      options = Haml::Template.options.dup
      if (ActionPack::VERSION::MAJOR >= 4) && template.respond_to?(:type)
        options[:mime_type] = template.type
      elsif template.respond_to? :mime_type
        options[:mime_type] = template.mime_type
      end
      options[:filename] = template.identifier
      Haml::Engine.new(template.source, options).compiler.precompiled_with_ambles([])
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

ActionView::Template.register_template_handler(:haml, Haml::Plugin)