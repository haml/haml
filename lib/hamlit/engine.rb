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

    def render(scope = Object.new, locals = {}, &block)
      scope = wrap_binding(scope)
      set_locals(locals, scope)
      eval(Engine.new.call(@template), scope)
    end

    private

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
