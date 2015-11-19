require 'temple'
require 'hamlit/parser'
require 'hamlit/compiler'
require 'hamlit/html'

module Hamlit
  class Engine < Temple::Engine
    define_options(
      generator:    Temple::Generators::ArrayBuffer,
      format:       :html,
      html_type:    nil,
      attr_quote:   "'",
      escape_html:  true,
      escape_attrs: true,
      autoclose:    %w(area base basefont br col command embed frame
                       hr img input isindex keygen link menuitem meta
                       param source track wbr),
      filename:     "",
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
