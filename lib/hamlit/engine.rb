require 'temple'
require 'hamlit/compiler'
require 'hamlit/html/pretty'
require 'hamlit/html/ugly'
require 'hamlit/parser'

module Hamlit
  class Engine < Temple::Engine
    define_options(
      generator:   Temple::Generators::ArrayBuffer,
      format:      :html,
      attr_quote:  "'",
      ugly:        true,
      escape_html: true,
    )

    use Parser
    use Compiler
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
        HTML::Ugly
      else
        HTML::Pretty
      end
    end
  end
end
