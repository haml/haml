require 'temple'
require 'hamlit/compiler'
require 'hamlit/html'
require 'hamlit/parser'
require 'hamlit/temple'

module Hamlit
  class Engine < Temple::Engine
    define_options(
      generator:   Temple::Generators::ArrayBuffer,
      format:      :html,
      attr_quote:  "'",
      escape_html: true,
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
end
