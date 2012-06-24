module Haml
  # This class encapsulates all of the configuration options that Haml
  # understands. Please see the {file:REFERENCE.md#options Haml Reference} to
  # learn how to set the options.
  class Options

    @defaults = {
      :attr_wrapper         => "'",
      :autoclose            => %w(meta img link br hr input area param col base),
      :encoding             => "UTF-8",
      :escape_attrs         => true,
      :escape_html          => false,
      :filename             => '(haml)',
      :format               => :xhtml,
      :hyphenate_data_attrs => true,
      :line                 => 1,
      :mime_type            => 'text/html',
      :preserve             => %w(textarea pre code),
      :remove_whitespace    => false,
      :suppress_eval        => false,
      :ugly                 => false,
      :cdata                => true
    }

    @valid_formats = [:xhtml, :html4, :html5]

    @buffer_option_keys = [:autoclose, :preserve, :attr_wrapper, :ugly, :format,
      :encoding, :escape_html, :escape_attrs, :hyphenate_data_attrs, :cdata]

    # The default option values.
    # @return Hash
    def self.defaults
      @defaults
    end

    # An array of valid values for the `:format` option.
    # @return Array
    def self.valid_formats
      @valid_formats
    end

    # An array of keys that will be used to provide a hash of options to
    # {Haml::Buffer}.
    # @return Hash
    def self.buffer_option_keys
      @buffer_option_keys
    end

    # The character that should wrap element attributes. This defaults to `'`
    # (an apostrophe). Characters of this type within the attributes will be
    # escaped (e.g. by replacing them with `&apos;`) if the character is an
    # apostrophe or a quotation mark.
    attr_reader :attr_wrapper

    # A list of tag names that should be automatically self-closed if they have
    # no content. This can also contain regular expressions that match tag names
    # (or any object which responds to `#===`). Defaults to `['meta', 'img',
    # 'link', 'br', 'hr', 'input', 'area', 'param', 'col', 'base']`.
    attr_accessor :autoclose

    # The encoding to use for the HTML output.
    # Only available on Ruby 1.9 or higher.
    # This can be a string or an `Encoding` Object. Note that Haml **does not**
    # automatically re-encode Ruby values; any strings coming from outside the
    # application should be converted before being passed into the Haml
    # template. Defaults to `Encoding.default_internal`; if that's not set,
    # defaults to the encoding of the Haml template; if that's `US-ASCII`,
    # defaults to `"UTF-8"`.
    attr_reader :encoding

    # Sets whether or not to escape HTML-sensitive characters in attributes. If
    # this is true, all HTML-sensitive characters in attributes are escaped. If
    # it's set to false, no HTML-sensitive characters in attributes are escaped.
    # If it's set to `:once`, existing HTML escape sequences are preserved, but
    # other HTML-sensitive characters are escaped.
    #
    # Defaults to `true`.
    attr_accessor :escape_attrs

    # Sets whether or not to escape HTML-sensitive characters in script. If this
    # is true, `=` behaves like {file:REFERENCE.md#escaping_html `&=`};
    # otherwise, it behaves like {file:REFERENCE.md#unescaping_html `!=`}. Note
    # that if this is set, `!=` should be used for yielding to subtemplates and
    # rendering partials. See also {file:REFERENCE.md#escaping_html Escaping HTML} and
    # {file:REFERENCE.md#unescaping_html Unescaping HTML}.
    #
    # Defaults to false.
    attr_accessor :escape_html

    # The name of the Haml file being parsed.
    # This is only used as information when exceptions are raised. This is
    # automatically assigned when working through ActionView, so it's really
    # only useful for the user to assign when dealing with Haml programatically.
    attr_accessor :filename

    # If set to `true`, Haml will convert underscores to hyphens in all
    # {file:REFERENCE.md#html5_custom_data_attributes Custom Data Attributes} As
    # of Haml 3.2, this defaults to `true`.
    attr_accessor :hyphenate_data_attrs

    # The line offset of the Haml template being parsed. This is useful for
    # inline templates, similar to the last argument to `Kernel#eval`.
    attr_accessor :line

    # Determines the output format. Normally the default is `:xhtml`, although
    # under Rails 3 it's `:html5`, since that's the Rails 3's default format.
    # Other options are `:html4` and `:html5`, which are identical to `:xhtml`
    # except there are no self-closing tags, the XML prolog is ignored and
    # correct DOCTYPEs are generated.
    #
    # If the mime_type of the template being rendered is `text/xml` then a
    # format of `:xhtml` will be used even if the global output format is set to
    # `:html4` or `:html5`.
    attr :format

    # The mime type that the rendered document will be served with. If this is
    # set to `text/xml` then the format will be overridden to `:xhtml` even if
    # it has set to `:html4` or `:html5`.
    attr_accessor :mime_type

    # A list of tag names that should automatically have their newlines
    # preserved using the {Haml::Helpers#preserve} helper. This means that any
    # content given on the same line as the tag will be preserved. For example,
    # `%textarea= "Foo\nBar"` compiles to `<textarea>Foo&#x000A;Bar</textarea>`.
    # Defaults to `['textarea', 'pre']`. See also
    # {file:REFERENCE.md#whitespace_preservation Whitespace Preservation}.
    attr_accessor :preserve

    # If set to `true`, all tags are treated as if both
    # {file:REFERENCE.md#whitespace_removal__and_ whitespace removal} options
    # were present. Use with caution as this may cause whitespace-related
    # formatting errors.
    #
    # Defaults to `false`.
    attr_reader :remove_whitespace

    # Whether or not attribute hashes and Ruby scripts designated by `=` or `~`
    # should be evaluated. If this is `true`, said scripts are rendered as empty
    # strings.
    #
    # Defaults to `false`.
    attr_accessor :suppress_eval

    # If set to `true`, Haml makes no attempt to properly indent or format the
    # HTML output. This significantly improves rendering performance but makes
    # viewing the source unpleasant.
    #
    # Defaults to `true` in Rails production  mode, and `false` everywhere else.
    attr_accessor :ugly

    # Whether to include CDATA sections around javascript blocks.
    #
    # Defaults to `true`. Can only be set to `false` if format is html.
    attr_accessor :cdata

    def initialize(values = {}, &block)
      defaults.each {|k, v| instance_variable_set :"@#{k}", v}
      values.reject {|k, v| !defaults.has_key?(k) || v.nil?}.each {|k, v| send("#{k}=", v)}
      yield if block_given?
    end

    # Retrieve an option value.
    # @param key The value to retrieve.
    def [](key)
      send key
    end

    # Set an option value.
    # @param key The key to set.
    # @param value The value to set for the key.
    def []=(key, value)
      send "#{key}=", value
    end

    [:escape_attrs, :hyphenate_data_attrs, :remove_whitespace, :suppress_eval,
      :ugly].each do |method|
      class_eval(<<-END)
        def #{method}?
          !! @#{method}
        end
      END
    end

    # @return [Boolean] Whether or not the format is XHTML.
    def xhtml?
      not html?
    end

    # @return [Boolean] Whether or not the format is any flavor of HTML.
    def html?
      html4? or html5?
    end

    # @return [Boolean] Whether or not the format is HTML4.
    def html4?
      format == :html4
    end

    # @return [Boolean] Whether or not the format is HTML5.
    def html5?
      format == :html5
    end

    def attr_wrapper=(value)
      @attr_wrapper = value || self.class.defaults[:attr_wrapper]
    end

    # Undef :format to suppress warning. It's defined above with the `:attr`
    # macro in order to make it appear in Yard's list of instance attributes.
    undef :format
    def format
      mime_type == "text/xml" ? :xhtml : @format
    end

    def format=(value)
      unless self.class.valid_formats.include?(value)
        raise Haml::Error, "Invalid output format #{value.inspect}"
      end
      @format = value
    end
    
    undef :cdata
    def cdata
      xhtml? || @cdata
    end

    def remove_whitespace=(value)
      @ugly = true if value
      @remove_whitespace = value
    end

    if RUBY_VERSION < "1.9"
      attr_writer :encoding
    else
      def encoding=(value)
        return unless value
        @encoding = value.is_a?(Encoding) ? value.name : value.to_s
        @encoding = "UTF-8" if @encoding.upcase == "US-ASCII"
      end
    end

    # Returns a subset of options: those that {Haml::Buffer} cares about.
    # All of the values here are such that when `#inspect` is called on the hash,
    # it can be `Kernel#eval`ed to get the same result back.
    #
    # See {file:REFERENCE.md#options the Haml options documentation}.
    #
    # @return [{Symbol => Object}] The options hash
    def for_buffer
      self.class.buffer_option_keys.inject({}) do |hash, key|
        hash[key] = send(key)
        hash
      end
    end

    private

    def defaults
      self.class.defaults
    end

  end
end