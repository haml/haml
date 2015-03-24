require 'temple'
require 'hamlit/attribute_compiler'
require 'hamlit/dynamic_formatter'
require 'hamlit/doctype_compiler'
require 'hamlit/filter_compiler'
require 'hamlit/filter_formatter'
require 'hamlit/html'
require 'hamlit/multiline_preprocessor'
require 'hamlit/new_attribute_compiler'
require 'hamlit/parser'
require 'hamlit/script_compiler'
require 'hamlit/text_compiler'

module Hamlit
  class Engine < Temple::Engine
    define_options(
      generator: Temple::Generators::ArrayBuffer,
      format:    :html,
    )

    use MultilinePreprocessor
    use Parser
    use DoctypeCompiler
    use AttributeCompiler
    use NewAttributeCompier
    use FilterFormatter
    use FilterCompiler
    use ScriptCompiler
    use TextCompiler
    use DynamicFormatter
    use HTML
    filter :Escapable
    filter :ControlFlow
    filter :MultiFlattener
    filter :StaticMerger

    use :Generator do
      valid_options = options.to_hash.select do |key, value|
        options[:generator].options.valid_key?(key)
      end
      options[:generator].new(valid_options)
    end
  end
end
