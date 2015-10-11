require 'temple'
require 'hamlit/compiler'
require 'hamlit/parser'

module Hamlit
  class Engine < Temple::Engine
    define_options(
      generator:   Temple::Generators::ArrayBuffer,
      format:      :html,
      attr_quote:  "'",
      escape_html: true,
      pretty:      false,
    )

    use Parser
    use Compiler
    html :Pretty
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
      Engine.new(temple_options).call(@template)
    end

    def render(scope = Object.new, locals = {}, &block)
      scope = wrap_binding(scope)
      set_locals(locals, scope)
      eval(precompiled, scope)
    end

    private

    def temple_options
      @options.dup.tap do |options|
        options[:pretty] = !options.delete(:ugly)
        options[:format] = :html if options[:format] == :html5
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
