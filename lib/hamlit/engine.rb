require 'temple'
require 'hamlit/parser'
require 'hamlit/compiler'
require 'hamlit/html'
require 'pretty_hamlit/engine'

module Hamlit
  class Engine < Temple::Engine
    define_options(
      generator:    Temple::Generators::ArrayBuffer,
      format:       :html,
      html_type:    nil,
      attr_quote:   "'",
      escape_html:  true,
      escape_attrs: true,
      buffer:       '_buf',
      autoclose:    %w(area base basefont br col command embed frame
                       hr img input isindex keygen link menuitem meta
                       param source track wbr),
      filename:     "",
    )

    use Parser
    use Compiler
    use HTML
    filter :Escapable
    filter :ControlFlow
    filter :MultiFlattener
    filter :StaticMerger
    use :Generator, -> { options[:generator] }
  end

  class HamlEngine
    def initialize(template, options = {})
      @template = template
      @options  = options
    end

    def precompiled
      if @options[:ugly]
        Engine.new(temple_options).call(@template)
      else
        PrettyHamlit::Engine.new(temple_options).call(@template)
      end
    end

    def render(scope = Object.new, locals = {}, &block)
      scope = wrap_binding(scope)
      set_locals(locals, scope)
      eval(precompiled, scope)
    end
    alias_method :to_html, :render

    private

    def temple_options
      @options.dup.tap do |options|
        options.delete(:ugly)
      end
    end

    def wrap_binding(scope)
      return scope if scope.is_a?(Binding)
      scope.instance_eval { binding }
    end

    def set_locals(locals, scope)
      set_locals = locals.map { |k, v| "#{k} = #{v.inspect}" }.join("\n")
      eval(set_locals, scope)
    end
  end
end
