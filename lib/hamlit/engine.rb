require 'temple'
require 'hamlit/attribute_compiler'
require 'hamlit/attribute_sorter'
require 'hamlit/dynamic_formatter'
require 'hamlit/doctype_compiler'
require 'hamlit/filter_compiler'
require 'hamlit/filter_formatter'
require 'hamlit/html/pretty'
require 'hamlit/multiline_preprocessor'
require 'hamlit/new_attribute_compiler'
require 'hamlit/parser'
require 'hamlit/script_compiler'
require 'hamlit/text_compiler'

module Hamlit
  class Engine < Temple::Engine
    define_options(
      generator:  Temple::Generators::ArrayBuffer,
      format:     :html,
      attr_quote: "'",
      ugly:       false,
    )

    use MultilinePreprocessor
    use Parser
    use DoctypeCompiler
    use AttributeCompiler
    use NewAttributeCompier
    use AttributeSorter
    use FilterFormatter
    use FilterCompiler
    use ScriptCompiler
    use TextCompiler
    use DynamicFormatter
    use :Html, -> { create(html_compiler) }
    filter :Escapable
    filter :ControlFlow
    filter :MultiFlattener
    filter :StaticMerger
    use :Generator, -> { create(options[:generator]) }

    private

    def create(klass)
      valid_options = options.to_hash.select do |key, value|
        klass.options.valid_key?(key)
      end
      klass.new(valid_options)
    end

    def html_compiler
      if options[:ugly]
        Temple::HTML::Fast
      else
        Hamlit::HTML::Pretty
      end
    end
  end
end
