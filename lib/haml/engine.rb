# frozen_string_literal: true
require 'temple'
require 'haml/parser'
require 'haml/compiler'
require 'haml/html'
require 'haml/escapable'
require 'haml/force_escapable'
require 'haml/dynamic_merger'
require 'haml/ambles'

module Haml
  class Engine < Temple::Engine
    define_options(
      :buffer_class,
      generator:    Temple::Generators::ArrayBuffer,
      format:       :html,
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
    filter :StringSplitter
    filter :StaticAnalyzer
    use Escapable
    use ForceEscapable
    filter :ControlFlow
    use Ambles
    filter :MultiFlattener
    filter :StaticMerger
    use DynamicMerger
    use :Generator, -> { options[:generator] }
  end
end
