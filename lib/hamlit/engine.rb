require 'temple'
require 'hamlit/attribute_compiler'
require 'hamlit/script_compiler'
require 'hamlit/parser'

module Hamlit
  class Engine < Temple::Engine
    define_options generator: Temple::Generators::ArrayBuffer

    use Parser
    use ScriptCompiler
    use AttributeCompiler
    html :Fast
    filter :Escapable
    filter :ControlFlow
    filter :MultiFlattener
    filter :StaticMerger
    use :Generator do
      options[:generator].new
    end
  end
end
