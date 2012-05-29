require 'erb'
require 'set'
require 'stringio'
require 'strscan'

module Haml
  # A module containing various useful functions.
  module Util
    extend self

    # An array of ints representing the Ruby version number.
    # @api public
    RUBY_VERSION = ::RUBY_VERSION.split(".").map {|s| s.to_i}

    # The Ruby engine we're running under. Defaults to `"ruby"`
    # if the top-level constant is undefined.
    # @api public
    RUBY_ENGINE = defined?(::RUBY_ENGINE) ? ::RUBY_ENGINE : "ruby"

    @@version_comparison_cache = {}

    # Returns the path of a file relative to the Haml root directory.
    #
    # @param file [String] The filename relative to the Haml root
    # @return [String] The filename relative to the the working directory
    def scope(file)
      File.expand_path("../../../#{file}", __FILE__)
    end

    # Converts an array of `[key, value]` pairs to a hash.
    #
    # @example
    #   to_hash([[:foo, "bar"], [:baz, "bang"]])
    #     #=> {:foo => "bar", :baz => "bang"}
    # @param arr [Array<(Object, Object)>] An array of pairs
    # @return [Hash] A hash
    def to_hash(arr)
      Hash[arr.compact]
    end

    # Maps the keys in a hash according to a block.
    #
    # @example
    #   map_keys({:foo => "bar", :baz => "bang"}) {|k| k.to_s}
    #     #=> {"foo" => "bar", "baz" => "bang"}
    # @param hash [Hash] The hash to map
    # @yield [key] A block in which the keys are transformed
    # @yieldparam key [Object] The key that should be mapped
    # @yieldreturn [Object] The new value for the key
    # @return [Hash] The mapped hash
    # @see #map_vals
    # @see #map_hash
    def map_keys(hash)
      to_hash(hash.map {|k, v| [yield(k), v]})
    end

    # Maps the key-value pairs of a hash according to a block.
    #
    # @example
    #   map_hash({:foo => "bar", :baz => "bang"}) {|k, v| [k.to_s, v.to_sym]}
    #     #=> {"foo" => :bar, "baz" => :bang}
    # @param hash [Hash] The hash to map
    # @yield [key, value] A block in which the key-value pairs are transformed
    # @yieldparam [key] The hash key
    # @yieldparam [value] The hash value
    # @yieldreturn [(Object, Object)] The new value for the `[key, value]` pair
    # @return [Hash] The mapped hash
    # @see #map_keys
    # @see #map_vals
    def map_hash(hash, &block)
      to_hash(hash.map(&block))
    end

    # Computes the powerset of the given array.
    # This is the set of all subsets of the array.
    #
    # @example
    #   powerset([1, 2, 3]) #=>
    #     Set[Set[], Set[1], Set[2], Set[3], Set[1, 2], Set[2, 3], Set[1, 3], Set[1, 2, 3]]
    # @param arr [Enumerable]
    # @return [Set<Set>] The subsets of `arr`
    def powerset(arr)
      arr.inject([Set.new].to_set) do |powerset, el|
        new_powerset = Set.new
        powerset.each do |subset|
          new_powerset << subset
          new_powerset << subset + [el]
        end
        new_powerset
      end
    end

    # Returns information about the caller of the previous method.
    #
    # @param entry [String] An entry in the `#caller` list, or a similarly formatted string
    # @return [[String, Fixnum, (String, nil)]] An array containing the filename, line, and method name of the caller.
    #   The method name may be nil
    def caller_info(entry = caller[1])
      info = entry.scan(/^(.*?):(-?.*?)(?::.*`(.+)')?$/).first
      info[1] = info[1].to_i
      # This is added by Rubinius to designate a block, but we don't care about it.
      info[2].sub!(/ \{\}\Z/, '') if info[2]
      info
    end

    # Returns whether one version string represents a more recent version than another.
    #
    # @param v1 [String] A version string.
    # @param v2 [String] Another version string.
    # @return [Boolean]
    def version_gt(v1, v2)
      # Construct an array to make sure the shorter version is padded with nil
      Array.new([v1.length, v2.length].max).zip(v1.split("."), v2.split(".")) do |_, p1, p2|
        p1 ||= "0"
        p2 ||= "0"
        release1 = p1 =~ /^[0-9]+$/
        release2 = p2 =~ /^[0-9]+$/
        if release1 && release2
          # Integer comparison if both are full releases
          p1, p2 = p1.to_i, p2.to_i
          next if p1 == p2
          return p1 > p2
        elsif !release1 && !release2
          # String comparison if both are prereleases
          next if p1 == p2
          return p1 > p2
        else
          # If only one is a release, that one is newer
          return release1
        end
      end
    end

    # Returns whether one version string represents the same or a more
    # recent version than another.
    #
    # @param v1 [String] A version string.
    # @param v2 [String] Another version string.
    # @return [Boolean]
    def version_geq(v1, v2)
      k = "#{v1}#{v2}"
      return @@version_comparison_cache.fetch(k) if @@version_comparison_cache.key?(k)
      @@version_comparison_cache[k] = version_gt(v1, v2) || !version_gt(v2, v1)
    end

    # Silence all output to STDERR within a block.
    #
    # @yield A block in which no output will be printed to STDERR
    def silence_warnings
      the_real_stderr, $stderr = $stderr, StringIO.new
      yield
    ensure
      $stderr = the_real_stderr
    end

    # Returns the environment of the Rails application,
    # if this is running in a Rails context.
    # Returns `nil` if no such environment is defined.
    #
    # @return [String, nil]
    def rails_env
      return ::Rails.env.to_s if defined?(::Rails.env)
      return RAILS_ENV.to_s if defined?(RAILS_ENV)
      return nil
    end

    # Returns whether this environment is using ActionPack
    # version 3.0.0 or greater.
    #
    # @return [Boolean]
    def ap_geq_3?
      ap_geq?("3.0.0.beta1")
    end

    # Returns whether this environment is using ActionPack
    # of a version greater than or equal to that specified.
    #
    # @param version [String] The string version number to check against.
    #   Should be greater than or equal to Rails 3,
    #   because otherwise ActionPack::VERSION isn't autoloaded
    # @return [Boolean]
    def ap_geq?(version)
      # The ActionPack module is always loaded automatically in Rails >= 3
      return false unless defined?(ActionPack) && defined?(ActionPack::VERSION) &&
        defined?(ActionPack::VERSION::STRING)

      version_geq(ActionPack::VERSION::STRING, version)
    end

    # Returns an ActionView::Template* class.
    # In pre-3.0 versions of Rails, most of these classes
    # were of the form `ActionView::TemplateFoo`,
    # while afterwards they were of the form `ActionView;:Template::Foo`.
    #
    # @param name [#to_s] The name of the class to get.
    #   For example, `:Error` will return `ActionView::TemplateError`
    #   or `ActionView::Template::Error`.
    def av_template_class(name)
      return ActionView.const_get("Template#{name}") if ActionView.const_defined?("Template#{name}")
      return ActionView::Template.const_get(name.to_s)
    end

    ## Rails XSS Safety

    # Whether or not ActionView's XSS protection is available and enabled,
    # as is the default for Rails 3.0+, and optional for version 2.3.5+.
    # Overridden in haml/template.rb if this is the case.
    #
    # @return [Boolean]
    def rails_xss_safe?
      false
    end

    # Returns the given text, marked as being HTML-safe.
    # With older versions of the Rails XSS-safety mechanism,
    # this destructively modifies the HTML-safety of `text`.
    #
    # @param text [String, nil]
    # @return [String, nil] `text`, marked as HTML-safe
    def html_safe(text)
      return unless text
      return text.html_safe if defined?(ActiveSupport::SafeBuffer)
      text.html_safe!
    end

    # The class for the Rails SafeBuffer XSS protection class.
    # This varies depending on Rails version.
    #
    # @return [Class]
    def rails_safe_buffer_class
      # It's important that we check ActiveSupport first,
      # because in Rails 2.3.6 ActionView::SafeBuffer exists
      # but is a deprecated proxy object.
      return ActiveSupport::SafeBuffer if defined?(ActiveSupport::SafeBuffer)
      return ActionView::SafeBuffer
    end

    ## Cross-OS Compatibility

    # Whether or not this is running on Windows.
    #
    # @return [Boolean]
    def windows?
      RbConfig::CONFIG['host_os'] =~ /mswin|windows|mingw/i
    end

    # Whether or not this is running on IronRuby.
    #
    # @return [Boolean]
    def ironruby?
      RUBY_ENGINE == "ironruby"
    end

    ## Cross-Ruby-Version Compatibility

    # Whether or not this is running under Ruby 1.8 or lower.
    #
    # Note that IronRuby counts as Ruby 1.8,
    # because it doesn't support the Ruby 1.9 encoding API.
    #
    # @return [Boolean]
    def ruby1_8?
      # IronRuby says its version is 1.9, but doesn't support any of the encoding APIs.
      # We have to fall back to 1.8 behavior.
      ironruby? || (Haml::Util::RUBY_VERSION[0] == 1 && Haml::Util::RUBY_VERSION[1] < 9)
    end

    # Checks that the encoding of a string is valid in Ruby 1.9
    # and cleans up potential encoding gotchas like the UTF-8 BOM.
    # If it's not, yields an error string describing the invalid character
    # and the line on which it occurrs.
    #
    # @param str [String] The string of which to check the encoding
    # @yield [msg] A block in which an encoding error can be raised.
    #   Only yields if there is an encoding error
    # @yieldparam msg [String] The error message to be raised
    # @return [String] `str`, potentially with encoding gotchas like BOMs removed
    def check_encoding(str)
      if ruby1_8?
        return str.gsub(/\A\xEF\xBB\xBF/, '') # Get rid of the UTF-8 BOM
      elsif str.valid_encoding?
        # Get rid of the Unicode BOM if possible
        if str.encoding.name =~ /^UTF-(8|16|32)(BE|LE)?$/
          return str.gsub(Regexp.new("\\A\uFEFF".encode(str.encoding.name)), '')
        else
          return str
        end
      end

      encoding = str.encoding
      newlines = Regexp.new("\r\n|\r|\n".encode(encoding).force_encoding("binary"))
      str.force_encoding("binary").split(newlines).each_with_index do |line, i|
        begin
          line.encode(encoding)
        rescue Encoding::UndefinedConversionError => e
          yield <<MSG.rstrip, i + 1
Invalid #{encoding.name} character #{e.error_char.dump}
MSG
        end
      end
      return str
    end

    # Like {\#check\_encoding}, but also checks for a Ruby-style `-# coding:` comment
    # at the beginning of the template and uses that encoding if it exists.
    #
    # The Haml encoding rules are simple.
    # If a `-# coding:` comment exists,
    # we assume that that's the original encoding of the document.
    # Otherwise, we use whatever encoding Ruby has.
    #
    # Haml uses the same rules for parsing coding comments as Ruby.
    # This means that it can understand Emacs-style comments
    # (e.g. `-*- encoding: "utf-8" -*-`),
    # and also that it cannot understand non-ASCII-compatible encodings
    # such as `UTF-16` and `UTF-32`.
    #
    # @param str [String] The Haml template of which to check the encoding
    # @yield [msg] A block in which an encoding error can be raised.
    #   Only yields if there is an encoding error
    # @yieldparam msg [String] The error message to be raised
    # @return [String] The original string encoded properly
    # @raise [ArgumentError] if the document declares an unknown encoding
    def check_haml_encoding(str, &block)
      return check_encoding(str, &block) if ruby1_8?
      str = str.dup if str.frozen?

      bom, encoding = parse_haml_magic_comment(str)
      if encoding; str.force_encoding(encoding)
      elsif bom; str.force_encoding("UTF-8")
      end

      return check_encoding(str, &block)
    end

    # Checks to see if a class has a given method.
    # For example:
    #
    #     Haml::Util.has?(:public_instance_method, String, :gsub) #=> true
    #
    # Method collections like `Class#instance_methods`
    # return strings in Ruby 1.8 and symbols in Ruby 1.9 and on,
    # so this handles checking for them in a compatible way.
    #
    # @param attr [#to_s] The (singular) name of the method-collection method
    #   (e.g. `:instance_methods`, `:private_methods`)
    # @param klass [Module] The class to check the methods of which to check
    # @param method [String, Symbol] The name of the method do check for
    # @return [Boolean] Whether or not the given collection has the given method
    def has?(attr, klass, method)
      klass.send("#{attr}s").include?(ruby1_8? ? method.to_s : method.to_sym)
    end

    # Like `Object#inspect`, but preserves non-ASCII characters rather than escaping them under Ruby 1.9.2.
    # This is necessary so that the precompiled Haml template can be `#encode`d into `@options[:encoding]`
    # before being evaluated.
    #
    # @param obj {Object}
    # @return {String}
    def inspect_obj(obj)
      return obj.inspect unless version_geq(::RUBY_VERSION, "1.9.2")
      return ':' + inspect_obj(obj.to_s) if obj.is_a?(Symbol)
      return obj.inspect unless obj.is_a?(String)
      '"' + obj.gsub(/[\x00-\x7F]+/) {|s| s.inspect[1...-1]} + '"'
    end

    ## Static Method Stuff

    # The context in which the ERB for \{#def\_static\_method} will be run.
    class StaticConditionalContext
      # @param set [#include?] The set of variables that are defined for this context.
      def initialize(set)
        @set = set
      end

      # Checks whether or not a variable is defined for this context.
      #
      # @param name [Symbol] The name of the variable
      # @return [Boolean]
      def method_missing(name, *args, &block)
        super unless args.empty? && block.nil?
        @set.include?(name)
      end
    end

    # This is used for methods in {Haml::Buffer} that need to be very fast,
    # and take a lot of boolean parameters
    # that are known at compile-time.
    # Instead of passing the parameters in normally,
    # a separate method is defined for every possible combination of those parameters;
    # these are then called using \{#static\_method\_name}.
    #
    # To define a static method, an ERB template for the method is provided.
    # All conditionals based on the static parameters
    # are done as embedded Ruby within this template.
    # For example:
    #
    #     def_static_method(Foo, :my_static_method, [:foo, :bar], :baz, :bang, <<RUBY)
    #       <% if baz && bang %>
    #         return foo + bar
    #       <% elsif baz || bang %>
    #         return foo - bar
    #       <% else %>
    #         return 17
    #       <% end %>
    #     RUBY
    #
    # \{#static\_method\_name} can be used to call static methods.
    #
    # @overload def_static_method(klass, name, args, *vars, erb)
    # @param klass [Module] The class on which to define the static method
    # @param name [#to_s] The (base) name of the static method
    # @param args [Array<Symbol>] The names of the arguments to the defined methods
    #   (**not** to the ERB template)
    # @param vars [Array<Symbol>] The names of the static boolean variables
    #   to be made available to the ERB template
    def def_static_method(klass, name, args, *vars)
      erb = vars.pop
      info = caller_info
      powerset(vars).each do |set|
        context = StaticConditionalContext.new(set).instance_eval {binding}
        klass.class_eval(<<METHOD, info[0], info[1])
def #{static_method_name(name, *vars.map {|v| set.include?(v)})}(#{args.join(', ')})
  #{ERB.new(erb).result(context)}
end
METHOD
      end
    end

    # Computes the name for a method defined via \{#def\_static\_method}.
    #
    # @param name [String] The base name of the static method
    # @param vars [Array<Boolean>] The static variable assignment
    # @return [String] The real name of the static method
    def static_method_name(name, *vars)
      "#{name}_#{vars.map {|v| !!v}.join('_')}"
    end

    private

    # Parses a magic comment at the beginning of a Haml file.
    # The parsing rules are basically the same as Ruby's.
    #
    # @return [(Boolean, String or nil)]
    #   Whether the document begins with a UTF-8 BOM,
    #   and the declared encoding of the document (or nil if none is declared)
    def parse_haml_magic_comment(str)
      scanner = StringScanner.new(str.dup.force_encoding("BINARY"))
      bom = scanner.scan(/\xEF\xBB\xBF/n)
      return bom unless scanner.scan(/-\s*#\s*/n)
      if coding = try_parse_haml_emacs_magic_comment(scanner)
        return bom, coding
      end

      return bom unless scanner.scan(/.*?coding[=:]\s*([\w-]+)/in)
      return bom, scanner[1]
    end

    def try_parse_haml_emacs_magic_comment(scanner)
      pos = scanner.pos
      return unless scanner.scan(/.*?-\*-\s*/n)
      # From Ruby's parse.y
      return unless scanner.scan(/([^\s'":;]+)\s*:\s*("(?:\\.|[^"])*"|[^"\s;]+?)[\s;]*-\*-/n)
      name, val = scanner[1], scanner[2]
      return unless name =~ /(en)?coding/in
      val = $1 if val =~ /^"(.*)"$/n
      return val
    ensure
      scanner.pos = pos
    end
  end
end
