module Haml
  # This class is used only internally. It holds the buffer of HTML that
  # is eventually output as the resulting document.
  # It's called from within the precompiled code,
  # and helps reduce the amount of processing done within `instance_eval`ed code.
  class Buffer
    include Haml::Helpers
    include Haml::Util

    # The string that holds the compiled HTML. This is aliased as
    # `_erbout` for compatibility with ERB-specific code.
    #
    # @return [String]
    attr_accessor :buffer

    # The options hash passed in from {Haml::Engine}.
    #
    # @return [{String => Object}]
    # @see Haml::Options#for_buffer
    attr_accessor :options

    # The {Buffer} for the enclosing Haml document.
    # This is set for partials and similar sorts of nested templates.
    # It's `nil` at the top level (see \{#toplevel?}).
    #
    # @return [Buffer]
    attr_accessor :upper

    # nil if there's no capture_haml block running,
    # and the position at which it's beginning the capture if there is one.
    #
    # @return [Fixnum, nil]
    attr_accessor :capture_position

    # @return [Boolean]
    # @see #active?
    attr_writer :active

    # @return [Boolean] Whether or not the format is XHTML
    def xhtml?
      not html?
    end

    # @return [Boolean] Whether or not the format is any flavor of HTML
    def html?
      html4? or html5?
    end

    # @return [Boolean] Whether or not the format is HTML4
    def html4?
      @options[:format] == :html4
    end

    # @return [Boolean] Whether or not the format is HTML5.
    def html5?
      @options[:format] == :html5
    end

    # @return [Boolean] Whether or not this buffer is a top-level template,
    #   as opposed to a nested partial
    def toplevel?
      upper.nil?
    end

    # Whether or not this buffer is currently being used to render a Haml template.
    # Returns `false` if a subtemplate is being rendered,
    # even if it's a subtemplate of this buffer's template.
    #
    # @return [Boolean]
    def active?
      @active
    end

    # @return [Fixnum] The current indentation level of the document
    def tabulation
      @real_tabs + @tabulation
    end

    # Sets the current tabulation of the document.
    #
    # @param val [Fixnum] The new tabulation
    def tabulation=(val)
      val = val - @real_tabs
      @tabulation = val > -1 ? val : 0
    end

    # @param upper [Buffer] The parent buffer
    # @param options [{Symbol => Object}] An options hash.
    #   See {Haml::Engine#options\_for\_buffer}
    def initialize(upper = nil, options = {})
      @active     = true
      @upper      = upper
      @options    = options
      @buffer     = new_encoded_string
      @tabulation = 0

      # The number of tabs that Engine thinks we should have
      # @real_tabs + @tabulation is the number of tabs actually output
      @real_tabs = 0
    end

    # Appends text to the buffer, properly tabulated.
    # Also modifies the document's indentation.
    #
    # @param text [String] The text to append
    # @param tab_change [Fixnum] The number of tabs by which to increase
    #   or decrease the document's indentation
    # @param dont_tab_up [Boolean] If true, don't indent the first line of `text`
    def push_text(text, tab_change, dont_tab_up)
      if @tabulation > 0
        # Have to push every line in by the extra user set tabulation.
        # Don't push lines with just whitespace, though,
        # because that screws up precompiled indentation.
        text.gsub!(/^(?!\s+$)/m, tabs)
        text.sub!(tabs, '') if dont_tab_up
      end

      @buffer << text
      @real_tabs += tab_change
    end

    # Modifies the indentation of the document.
    #
    # @param tab_change [Fixnum] The number of tabs by which to increase
    #   or decrease the document's indentation
    def adjust_tabs(tab_change)
      @real_tabs += tab_change
    end

    Haml::Util.def_static_method(self, :format_script, [:result],
                                 :preserve_script, :in_tag, :preserve_tag, :escape_html,
                                 :nuke_inner_whitespace, :interpolated, :ugly, <<RUBY)
      <% # Escape HTML here so that the safety of the string is preserved in Rails
         result_name = escape_html ? "html_escape(result.to_s)" : "result.to_s" %>
      <% unless ugly %>
        # If we're interpolated,
        # then the custom tabulation is handled in #push_text.
        # The easiest way to avoid it here is to reset @tabulation.
        <% if interpolated %>
          old_tabulation = @tabulation
          @tabulation = 0
        <% end %>

        <% if !(in_tag && preserve_tag && !nuke_inner_whitespace) %>
        tabulation = @real_tabs
        <% end %>
        result = <%= result_name %>.<% if nuke_inner_whitespace %>strip<% else %>rstrip<% end %>
      <% else %>
        result = <%= result_name %><% if nuke_inner_whitespace %>.strip<% end %>
      <% end %>

      <% if preserve_tag %>
        result = Haml::Helpers.preserve(result)
      <% elsif preserve_script %>
        result = Haml::Helpers.find_and_preserve(result, options[:preserve])
      <% end %>

      <% if ugly %>
        fix_textareas!(result) if toplevel? && result.include?('<textarea')
        return result
      <% else %>
        <% if !(in_tag && preserve_tag && !nuke_inner_whitespace) %>
        has_newline = result.include?("\\n")
        <% end %>

        <% if in_tag && !nuke_inner_whitespace %>
          <% unless preserve_tag %> if !has_newline <% end %>
          @real_tabs -= 1
          <% if interpolated %> @tabulation = old_tabulation <% end %>
          return result
          <% unless preserve_tag %> end <% end %>
        <% end %>

        <% if !(in_tag && preserve_tag && !nuke_inner_whitespace) %>
        # Precompiled tabulation may be wrong
        <% if !interpolated && !in_tag %>
          result = tabs + result if @tabulation > 0
        <% end %>

        if has_newline
          result = result.gsub "\\n", "\\n" + tabs(tabulation)

          # Add tabulation if it wasn't precompiled
          <% if in_tag && !nuke_inner_whitespace %> result = tabs(tabulation) + result <% end %>
        end

        fix_textareas!(result) if toplevel? && result.include?('<textarea')

        <% if in_tag && !nuke_inner_whitespace %>
          result = "\\n\#{result}\\n\#{tabs(tabulation-1)}"
          @real_tabs -= 1
        <% end %>
        <% if interpolated %> @tabulation = old_tabulation <% end %>
        result
        <% end %>
      <% end %>
RUBY

    def attributes(class_id, obj_ref, *attributes_hashes)
      attributes = class_id
      attributes_hashes.each do |old|
        self.class.merge_attrs(attributes, Hash[old.map {|k, v| [k.to_s, v]}])
      end
      self.class.merge_attrs(attributes, parse_object_ref(obj_ref)) if obj_ref
      Compiler.build_attributes(
        html?, @options[:attr_wrapper], @options[:escape_attrs], @options[:hyphenate_data_attrs], attributes)
    end

    # Remove the whitespace from the right side of the buffer string.
    # Doesn't do anything if we're at the beginning of a capture_haml block.
    def rstrip!
      if capture_position.nil?
        buffer.rstrip!
        return
      end

      buffer << buffer.slice!(capture_position..-1).rstrip
    end

    # Merges two attribute hashes.
    # This is the same as `to.merge!(from)`,
    # except that it merges id, class, and data attributes.
    #
    # ids are concatenated with `"_"`,
    # and classes are concatenated with `" "`.
    # data hashes are simply merged.
    #
    # Destructively modifies both `to` and `from`.
    #
    # @param to [{String => String}] The attribute hash to merge into
    # @param from [{String => #to_s}] The attribute hash to merge from
    # @return [{String => String}] `to`, after being merged
    def self.merge_attrs(to, from)
      from['id'] = Compiler.filter_and_join(from['id'], '_') if from['id']
      if to['id'] && from['id']
        to['id'] << '_' << from.delete('id').to_s
      elsif to['id'] || from['id']
        from['id'] ||= to['id']
      end

      from['class'] = Compiler.filter_and_join(from['class'], ' ') if from['class']
      if to['class'] && from['class']
        # Make sure we don't duplicate class names
        from['class'] = (from['class'].to_s.split(' ') | to['class'].split(' ')).sort.join(' ')
      elsif to['class'] || from['class']
        from['class'] ||= to['class']
      end

      from_data = from.delete('data') || {}
      to_data = to.delete('data') || {}

      # forces to_data & from_data into a hash
      from_data = { nil => from_data } unless from_data.is_a?(Hash)
      to_data = { nil => to_data } unless to_data.is_a?(Hash)

      merged_data = to_data.merge(from_data)

      to['data'] = merged_data unless merged_data.empty?
      to.merge!(from)
    end

    private

    # Works like #{find_and_preserve}, but allows the first newline after a
    # preserved opening tag to remain unencoded, and then outdents the content.
    # This change was motivated primarily by the change in Rails 3.2.3 to emit
    # a newline after textarea helpers.
    #
    # @param input [String] The text to process
    # @since Haml 4.0.1
    # @private
    def fix_textareas!(input)
      pattern = /([ ]*)<(textarea)([^>]*)>(\n|&#x000A;)(.*?)(<\/\2>)/im
      input.gsub!(pattern) do |s|
        match = pattern.match(s)
        content = match[5]
        if match[4] == '&#x000A;'
          content.sub!(/\A /, '&#x0020;')
        else
          content.sub!(/\A[ ]*/, '')
        end
        "#{match[1]}<#{match[2]}#{match[3]}>\n#{content}</#{match[2]}>"
      end
    end

    if RUBY_VERSION < "1.9"
      def new_encoded_string
        ""
      end
    else
      def new_encoded_string
        "".encode(Encoding.find(options[:encoding]))
      end
    end

    @@tab_cache = {}
    # Gets `count` tabs. Mostly for internal use.
    def tabs(count = 0)
      tabs = [count + @tabulation, 0].max
      @@tab_cache[tabs] ||= '  ' * tabs
    end

    # Takes an array of objects and uses the class and id of the first
    # one to create an attributes hash.
    # The second object, if present, is used as a prefix,
    # just like you can do with `dom_id()` and `dom_class()` in Rails
    def parse_object_ref(ref)
      prefix = ref[1]
      ref = ref[0]
      # Let's make sure the value isn't nil. If it is, return the default Hash.
      return {} if ref.nil?
      class_name =
        if ref.respond_to?(:haml_object_ref)
          ref.haml_object_ref
        else
          underscore(ref.class)
        end
      ref_id =
        if ref.respond_to?(:to_key)
          key = ref.to_key
          key.join('_') unless key.nil?
        else
          ref.id
        end
      id = "#{class_name}_#{ref_id || 'new'}"
      if prefix
        class_name = "#{ prefix }_#{ class_name}"
        id = "#{ prefix }_#{ id }"
      end

      {'id' => id, 'class' => class_name}
    end

    # Changes a word from camel case to underscores.
    # Based on the method of the same name in Rails' Inflector,
    # but copied here so it'll run properly without Rails.
    def underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '_').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
  end
end
