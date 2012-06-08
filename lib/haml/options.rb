module Haml
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
      :mime_type            => nil,
      :preserve             => %w(textarea pre code),
      :remove_whitespace    => false,
      :suppress_eval        => false,
      :ugly                 => false
    }

    @valid_formats = [:xhtml, :html4, :html5]

    @buffer_option_keys = [:autoclose, :preserve, :attr_wrapper, :ugly, :format,
      :encoding, :escape_html, :escape_attrs, :hyphenate_data_attrs]


    def self.defaults
      @defaults
    end

    def self.valid_formats
      @valid_formats
    end

    def self.buffer_option_keys
      @buffer_option_keys
    end

    attr_accessor :autoclose
    attr_accessor :escape_attrs
    attr_accessor :escape_html
    attr_accessor :filename
    attr_accessor :hyphenate_data_attrs
    attr_accessor :line
    attr_accessor :preserve
    attr_accessor :suppress_eval
    attr_accessor :ugly

    attr_reader :attr_wrapper
    attr_reader :encoding
    attr_reader :format
    attr_reader :mime_type
    attr_reader :remove_whitespace

    def initialize(values = {}, &block)
      defaults.each {|k, v| instance_variable_set :"@#{k}", v}
      values.reject {|k, v| !defaults.has_key?(k) || v.nil?}.each {|k, v| send("#{k}=", v)}
      # Setting the mime type will override the :format option, so ensure it's
      # called *after* the format option has been set.
      self.mime_type = values[:mime_type] if values.has_key?(:mime_type)
      yield if block_given?
    end

    def [](key)
      send key
    end

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

    def xhtml?
      not html?
    end

    # @return [Boolean] Whether or not the format is any flavor of HTML.
    def html?
      html4? or html5?
    end

    # @return [Boolean] Whether or not the format is HTML4.
    def html4?
      @format == :html4
    end

    # @return [Boolean] Whether or not the format is HTML5.
    def html5?
      @format == :html5
    end

    def attr_wrapper=(value)
      @attr_wrapper = value || self.class.defaults[:attr_wrapper]
    end

    def mime_type=(value)
      @format = :xhtml if value == 'text/xml'
      @mime_type = value
    end

    def format=(value)
      unless self.class.valid_formats.include?(value)
        raise Haml::Error, "Invalid output format #{value.inspect}"
      end
      @format = value
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

    # Returns a subset of \{#options}: those that {Haml::Buffer} cares about.
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