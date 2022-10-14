# frozen_string_literal: true
require 'temple'
require 'haml/parser'
require 'haml/compiler'
require 'haml/html'
require 'haml/string_splitter'
require 'haml/escapable'
require 'haml/force_escapable'
require 'haml/dynamic_merger'
require 'haml/ambles'

module Haml
  class Engine < Temple::Engine
    define_options(
      :buffer_class,
      generator:    Temple::Generators::StringBuffer,
      format:       :html,
      attr_quote:   "'",
      escape_html:  true,
      escape_attrs: true,
      autoclose:    %w(area base basefont br col command embed frame
                       hr img input isindex keygen link menuitem meta
                       param source track wbr),
      filename:     "",
      disable_capture: false,
      remove_whitespace: false,
    )

    use Parser
    use Compiler
    use HTML
    use StringSplitter
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

  # For backward compatibility of Tilt integration. TODO: We should deprecate this
  # and let Tilt have a native support of Haml 6. At least it generates warnings now.
  class TempleEngine < Engine
    def compile(template)
      @precompiled = call(template)
    end

    def precompiled_with_ambles(_local_names, after_preamble:)
      "#{after_preamble.tr("\n", ';')}#{@precompiled}".dup
    end
  end
end
