require "tilt"

module Haml
  # The module containing the default Haml filters,
  # as well as the base module, {Haml::Filters::Base}.
  #
  # @see Haml::Filters::Base
  module Filters
    # @return [{String => Haml::Filters::Base}] a hash of filter names to classes
    def self.defined
      @defined ||= {}
    end

    # The base module for Haml filters.
    # User-defined filters should be modules including this module.
    # The name of the filter is taken by downcasing the module name.
    # For instance, if the module is named `FooBar`, the filter will be `:foobar`.
    #
    # A user-defined filter should override either \{#render} or {\#compile}.
    # \{#render} is the most common.
    # It takes a string, the filter source,
    # and returns another string, the result of the filter.
    # For example, the following will define a filter named `:sass`:
    #
    #     module Haml::Filters::Sass
    #       include Haml::Filters::Base
    #
    #       def render(text)
    #         ::Sass::Engine.new(text).render
    #       end
    #     end
    #
    # For details on overriding \{#compile}, see its documentation.
    #
    # Note that filters overriding \{#render} automatically support `#{}`
    # for interpolating Ruby code.
    # Those overriding \{#compile} will need to add such support manually
    # if it's desired.
    module Base
      # This method is automatically called when {Base} is included in a module.
      # It automatically defines a filter
      # with the downcased name of that module.
      # For example, if the module is named `FooBar`, the filter will be `:foobar`.
      #
      # @param base [Module, Class] The module that this is included in
      def self.included(base)
        Filters.defined[base.name.split("::").last.downcase] = base
        base.extend(base)
      end

      # Takes the source text that should be passed to the filter
      # and returns the result of running the filter on that string.
      #
      # This should be overridden in most individual filter modules
      # to render text with the given filter.
      # If \{#compile} is overridden, however, \{#render} doesn't need to be.
      #
      # @param text [String] The source text for the filter to process
      # @return [String] The filtered result
      # @raise [Haml::Error] if it's not overridden
      def render(text)
        raise Error.new("#{self.inspect}#render not defined!")
      end

      # Same as \{#render}, but takes a {Haml::Engine} options hash as well.
      # It's only safe to rely on options made available in {Haml::Engine#options\_for\_buffer}.
      #
      # @see #render
      # @param text [String] The source text for the filter to process
      # @return [String] The filtered result
      # @raise [Haml::Error] if it or \{#render} isn't overridden
      def render_with_options(text, options)
        render(text)
      end

      # Same as \{#compile}, but requires the necessary files first.
      # *This is used by {Haml::Engine} and is not intended to be overridden or used elsewhere.*
      #
      # @see #compile
      def internal_compile(*args)
        resolve_lazy_requires
        compile(*args)
      end

      # This should be overridden when a filter needs to have access to the Haml evaluation context.
      # Rather than applying a filter to a string at compile-time,
      # \{#compile} uses the {Haml::Compiler} instance to compile the string to Ruby code
      # that will be executed in the context of the active Haml template.
      #
      # Warning: the {Haml::Compiler} interface is neither well-documented
      # nor guaranteed to be stable.
      # If you want to make use of it, you'll probably need to look at the source code
      # and should test your filter when upgrading to new Haml versions.
      #
      # @param compiler [Haml::Compiler] The compiler instance
      # @param text [String] The text of the filter
      # @raise [Haml::Error] if none of \{#compile}, \{#render}, and \{#render_with_options} are overridden
      def compile(compiler, text)
        resolve_lazy_requires
        filter = self
        compiler.instance_eval do
          if contains_interpolation?(text)
            return if options[:suppress_eval]

            text = unescape_interpolation(text).gsub(/(\\+)n/) do |s|
              escapes = $1.size
              next s if escapes % 2 == 0
              ("\\" * (escapes - 1)) + "\n"
            end
            # We need to add a newline at the beginning to get the
            # filter lines to line up (since the Haml filter contains
            # a line that doesn't show up in the source, namely the
            # filter name). Then we need to escape the trailing
            # newline so that the whole filter block doesn't take up
            # too many.
            text = "\n" + text.sub(/\n"\Z/, "\\n\"")
            push_script <<RUBY.rstrip, :escape_html => false
find_and_preserve(#{filter.inspect}.render_with_options(#{text}, _hamlout.options))
RUBY
            return
          end

          rendered = Haml::Helpers::find_and_preserve(filter.render_with_options(text, compiler.options), compiler.options[:preserve])

          if !options[:ugly]
            push_text(rendered.rstrip.gsub("\n", "\n#{'  ' * @output_tabs}"))
          else
            push_text(rendered.rstrip)
          end
        end
      end

      # This becomes a class method of modules that include {Base}.
      # It allows the module to specify one or more Ruby files
      # that Haml should try to require when compiling the filter.
      #
      # The first file specified is tried first, then the second, etc.
      # If none are found, the compilation throws an exception.
      #
      # For example:
      #
      #     module Haml::Filters::Markdown
      #       lazy_require 'rdiscount', 'peg_markdown', 'maruku', 'bluecloth', 'kramdown'
      #
      #       ...
      #     end
      #
      # @param reqs [Array<String>] The requires to run
      def lazy_require(*reqs)
        @lazy_requires = reqs
      end

      private

      def resolve_lazy_requires
        return unless instance_variable_defined?('@lazy_requires')

        @lazy_requires[0...-1].each do |req|
          begin
            @required = req
            require @required
            return
          rescue LoadError; end # RCov doesn't see this, but it is run
        end

        begin
          @required = @lazy_requires[-1]
          require @required
        rescue LoadError
          classname = self.name.match(/\w+$/)[0]

          if @lazy_requires.size == 1
            raise Error.new("Can't run #{classname} filter; required file '#{@lazy_requires.first}' not found")
          else
            raise Error.new("Can't run #{classname} filter; required #{@lazy_requires.map { |r| "'#{r}'" }.join(' or ')}, but none were found")
          end
        end
      end
    end
  end
end

begin
  require 'rubygems'
rescue LoadError; end

module Haml
  module Filters

    # Does not parse the filtered text.
    # This is useful for large blocks of text without HTML tags,
    # when you don't want lines starting with `.` or `-`
    # to be parsed.
    module Plain
      include Base

      # @see Base#render
      def render(text); text; end
    end

    # Surrounds the filtered text with `<script>` and CDATA tags.
    # Useful for including inline Javascript.
    module Javascript
      include Base

      # @see Base#render_with_options
      def render_with_options(text, options)
        if options[:format] == :html5
          type = ''
        else
          type = " type=#{options[:attr_wrapper]}text/javascript#{options[:attr_wrapper]}"
        end

        <<END
<script#{type}>
  //<![CDATA[
    #{text.rstrip.gsub("\n", "\n    ")}
  //]]>
</script>
END
      end
    end

    # Surrounds the filtered text with `<style>` and CDATA tags.
    # Useful for including inline CSS.
    module Css
      include Base

      # @see Base#render_with_options
      def render_with_options(text, options)
        if options[:format] == :html5
          type = ''
        else
          type = " type=#{options[:attr_wrapper]}text/css#{options[:attr_wrapper]}"
        end

        <<END
<style#{type}>
  /*<![CDATA[*/
    #{text.rstrip.gsub("\n", "\n    ")}
  /*]]>*/
</style>
END
      end
    end

    module TiltFilter
      extend self
      attr_accessor :template_class, :tilt_extension

      def template_class
        @template_class or begin
          @template_class = Tilt["t.#{tilt_extension}"]
        rescue LoadError
          raise Error.new("Can't run #{self} filter; required dependencies not available")
        end
      end

      def self.extended(base)
        base.instance_eval do
          def render(text)
            template_class.new {text}.render
          end
        end
      end
    end

    module PrecompiledFilter
      def precompiled(text)
        template_class.new { text }.send(:precompiled, {}).first
      end

      def compile(compiler, text)
        return if compiler.options[:suppress_eval]
        compiler.send(:push_script, precompiled(text))
      end
    end

    template_engines = {
      "Sass"     => "sass",
      "Scss"     => "scss",
      "Less"     => "less",
      "Markdown" => "markdown",
      "Coffee"   => "coffee",
      "Nokogiri" => "nokogiri",
      "Builder"  => "builder",
      "Markaby"  => "mab",
      "Erb"      => "erb"
    }

    template_engines.each do |name, extension|
      module_eval(<<-END)
        module #{name}
          include Base
          extend TiltFilter
        end
        # Let Tilt figure out which library to use, since there are lot of engine
        # for Markdown, and may eventually be more than one for Sass, Less, etc.
        #{name}.tilt_extension = '#{extension}'
      END
    end

    # Some filters precompile for performance
    Nokogiri.extend PrecompiledFilter
    Builder.extend  PrecompiledFilter
    Erb.extend  PrecompiledFilter

    # Parses the filtered text with ERB.
    # Not available if the {file:REFERENCE.md#suppress_eval-option
    # `:suppress_eval`} option is set to true. Embedded Ruby code is evaluated
    # in the same context as the Haml template.
    module Erb
      class << self
        def precompiled(text)
          super.sub(/^#coding:.*?\n/, '')
        end
      end
    end

    # Allow :coffee as a longhand for :coffee
    Filters.defined["coffeescript"] = Coffee

    # Maruku has no dedicated extension
    module Maruku
      include Base
      extend TiltFilter
    end
    Maruku.template_class = Tilt::MarukuTemplate

    # Surrounds the filtered text with CDATA tags.
    module Cdata
      include Base

      # @see Base#render
      def render(text)
        "<![CDATA[#{("\n" + text).rstrip.gsub("\n", "\n    ")}\n]]>"
      end
    end

    # Works the same as {Plain}, but HTML-escapes the text
    # before placing it in the document.
    module Escaped
      include Base

      # @see Base#render
      def render(text)
        Haml::Helpers.html_escape text
      end
    end

    # Parses the filtered text with the normal Ruby interpreter.
    # All output sent to `$stdout`, such as with `puts`,
    # is output into the Haml document.
    # Not available if the {file:REFERENCE.md#suppress_eval-option `:suppress_eval`} option is set to true.
    # The Ruby code is evaluated in the same context as the Haml template.
    module Ruby
      include Base
      require 'stringio'

      # @see Base#compile
      def compile(compiler, text)
        return if compiler.options[:suppress_eval]
        compiler.instance_eval do
          push_silent <<-FIRST.gsub("\n", ';') + text + <<-LAST.gsub("\n", ';')
            _haml_old_stdout = $stdout
            $stdout = StringIO.new(_hamlout.buffer, 'a')
          FIRST
            _haml_old_stdout, $stdout = $stdout, _haml_old_stdout
            _haml_old_stdout.close
          LAST
        end
      end
    end

    # Inserts the filtered text into the template with whitespace preserved.
    # `preserve`d blocks of text aren't indented,
    # and newlines are replaced with the HTML escape code for newlines,
    # to preserve nice-looking output.
    #
    # @see Haml::Helpers#preserve
    module Preserve
      include Base

      # @see Base#render
      def render(text)
        Haml::Helpers.preserve text
      end
    end
  end
end
