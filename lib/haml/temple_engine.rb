require 'temple'

module Haml
  class EngineFilter
    def initialize(options = {})
      @options = Options.new(options)
    end

    def call(template)
      parser    = @options.parser_class.new(template, @options)
      @compiler = @options.compiler_class.new(@options)

      @compiler.compile(parser.parse)
      @compiler.precompiled_with_return_value
    end
  end

  class TempleEngine < Temple::Engine
    define_options(
      :attr_wrapper         => "'",
      :autoclose            => %w(area base basefont br col command embed frame
                                  hr img input isindex keygen link menuitem meta
                                  param source track wbr),
      :encoding             => nil,
      :escape_attrs         => true,
      :escape_html          => false,
      :filename             => '(haml)',
      :format               => :html5,
      :hyphenate_data_attrs => true,
      :line                 => 1,
      :mime_type            => 'text/html',
      :preserve             => %w(textarea pre code),
      :remove_whitespace    => false,
      :suppress_eval        => false,
      :ugly                 => false,
      :cdata                => false,
      :parser_class         => ::Haml::Parser,
      :compiler_class       => ::Haml::Compiler,
      :trace                => false
    )

    use EngineFilter

    def compile(template)
      initialize_encoding(template, options[:encoding])
      @precompiled = call(template)
    end

    def precompiled
      encoding = Encoding.find(@encoding || '')
      return @precompiled.force_encoding(encoding) if encoding == Encoding::ASCII_8BIT
      return @precompiled.encode(encoding)
    end

    def precompiled_with_return_value
      "#{precompiled};#{precompiled_method_return_value}"
    end

    private

    def initialize_encoding(template, given_value)
      if given_value
        @encoding = given_value
      else
        @encoding = Encoding.default_internal || template.encoding
      end
    end

    # Returns the string used as the return value of the precompiled method.
    # This method exists so it can be monkeypatched to return modified values.
    def precompiled_method_return_value
      "_erbout"
    end
  end
end
