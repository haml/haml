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
      eval Engine.new.call(@template)
    end
  end
end
