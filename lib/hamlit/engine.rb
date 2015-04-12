require 'temple'
require 'hamlit/compiler'
require 'hamlit/html'
require 'hamlit/parser'

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
    use :Generator, -> { create(options[:generator]) }

    private

    def create(klass)
      valid_options = options.to_hash.select do |key, value|
        klass.options.valid_key?(key)
      end
      klass.new(valid_options)
    end
  end
end
