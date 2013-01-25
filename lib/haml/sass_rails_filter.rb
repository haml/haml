module Haml
  module Filters
    # This is an extension of Sass::Rails's SassTemplate class that allows
    # Rails's asset helpers to be used inside Haml Sass filter.
    class SassRailsTemplate < ::Sass::Rails::SassTemplate
      def render(scope=Object.new, locals={}, &block)
        scope = ::Rails.application.assets.context_class.new(::Rails.application.assets, "/", "/")
        super
      end

      def sass_options(scope)
        options = super
        options[:custom][:resolver] = ::ActionView::Base.new
        options
      end
    end

    # This is an extension of Sass::Rails's SassTemplate class that allows
    # Rails's asset helpers to be used inside a Haml SCSS filter.
    class ScssRailsTemplate < SassRailsTemplate
      self.default_mime_type = 'text/css'

      def syntax
        :scss
      end
    end

    remove_filter :Sass
    remove_filter :Scss
    register_tilt_filter "Sass", :extend => "Css", :template_class => SassRailsTemplate
    register_tilt_filter "Scss", :extend => "Css", :template_class => ScssRailsTemplate
  end
end