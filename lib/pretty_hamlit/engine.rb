require 'temple'
require 'hamlit/parser'
require 'pretty_hamlit/compiler'
require 'pretty_hamlit/dynamic_indentation'

module PrettyHamlit
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

    use Hamlit::Parser
    use Compiler
    html :Fast
    filter :Escapable
    filter :ControlFlow
    filter :MultiFlattener
    filter :StaticMerger
    use :Generator, -> { options[:generator] }
  end
end
