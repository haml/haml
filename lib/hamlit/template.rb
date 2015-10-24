module Hamlit
  # This module makes Haml work with Rails using the template handler API.
  class Plugin
    def handles_encoding?; true; end

    def compile(template)
      options = {}
      options[:filename] = template.identifier
      options[:ugly] = defined?(Rails.env) ? !Rails.env.development? : true
      options[:escape_html] = true
      options[:generator] = Temple::Generators::RailsOutputBuffer
      HamlEngine.new(template.source, options).precompiled
    end

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

require 'haml/template' # load first to force overwrite
ActionView::Template.register_template_handler(:haml, Hamlit::Plugin)
