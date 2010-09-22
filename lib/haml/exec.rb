require 'optparse'
require 'fileutils'

module Haml
  # This module handles the various Haml executables (`haml` and `haml-convert`).
  module Exec
    # An abstract class that encapsulates the executable code for all three executables.
    class Generic
      # @param args [Array<String>] The command-line arguments
      def initialize(args)
        @args = args
        @options = {}
      end

      # Parses the command-line arguments and runs the executable.
      # Calls `Kernel#exit` at the end, so it never returns.
      #
      # @see #parse
      def parse!
        begin
          parse
        rescue Exception => e
          raise e if @options[:trace] || e.is_a?(SystemExit)

          $stderr.print "#{e.class}: " unless e.class == RuntimeError
          $stderr.puts "#{e.message}"
          $stderr.puts "  Use --trace for backtrace."
          exit 1
        end
        exit 0
      end

      # Parses the command-line arguments and runs the executable.
      # This does not handle exceptions or exit the program.
      #
      # @see #parse!
      def parse
        @opts = OptionParser.new(&method(:set_opts))
        @opts.parse!(@args)

        process_result

        @options
      end

      # @return [String] A description of the executable
      def to_s
        @opts.to_s
      end

      protected

      # Finds the line of the source template
      # on which an exception was raised.
      #
      # @param exception [Exception] The exception
      # @return [String] The line number
      def get_line(exception)
        # SyntaxErrors have weird line reporting
        # when there's trailing whitespace,
        # which there is for Haml documents.
        return (exception.message.scan(/:(\d+)/).first || ["??"]).first if exception.is_a?(::SyntaxError)
        (exception.backtrace[0].scan(/:(\d+)/).first || ["??"]).first
      end

      # Tells optparse how to parse the arguments
      # available for all executables.
      #
      # This is meant to be overridden by subclasses
      # so they can add their own options.
      #
      # @param opts [OptionParser]
      def set_opts(opts)
        opts.on('-s', '--stdin', :NONE, 'Read input from standard input instead of an input file') do
          @options[:input] = $stdin
        end

        opts.on('--trace', :NONE, 'Show a full traceback on error') do
          @options[:trace] = true
        end

        opts.on('--unix-newlines', 'Use Unix-style newlines in written files.') do
          @options[:unix_newlines] = true if ::Haml::Util.windows?
        end

        opts.on_tail("-?", "-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("-v", "--version", "Print version") do
          puts("Haml #{::Haml.version[:string]}")
          exit
        end
      end

      # Processes the options set by the command-line arguments.
      # In particular, sets `@options[:input]` and `@options[:output]`
      # to appropriate IO streams.
      #
      # This is meant to be overridden by subclasses
      # so they can run their respective programs.
      def process_result
        input, output = @options[:input], @options[:output]
        args = @args.dup
        input ||=
          begin
            filename = args.shift
            @options[:filename] = filename
            open_file(filename) || $stdin
          end
        output ||= open_file(args.shift, 'w') || $stdout

        @options[:input], @options[:output] = input, output
      end

      COLORS = { :red => 31, :green => 32, :yellow => 33 }

      # Prints a status message about performing the given action,
      # colored using the given color (via terminal escapes) if possible.
      #
      # @param name [#to_s] A short name for the action being performed.
      #   Shouldn't be longer than 11 characters.
      # @param color [Symbol] The name of the color to use for this action.
      #   Can be `:red`, `:green`, or `:yellow`.
      def puts_action(name, color, arg)
        printf color(color, "%11s %s\n"), name, arg
      end

      # Wraps the given string in terminal escapes
      # causing it to have the given color.
      # If terminal esapes aren't supported on this platform,
      # just returns the string instead.
      #
      # @param color [Symbol] The name of the color to use.
      #   Can be `:red`, `:green`, or `:yellow`.
      # @param str [String] The string to wrap in the given color.
      # @return [String] The wrapped string.
      def color(color, str)
        raise "[BUG] Unrecognized color #{color}" unless COLORS[color]

        # Almost any real Unix terminal will support color,
        # so we just filter for Windows terms (which don't set TERM)
        # and not-real terminals, which aren't ttys.
        return str if ENV["TERM"].nil? || ENV["TERM"].empty? || !STDOUT.tty?
        return "\e[#{COLORS[color]}m#{str}\e[0m"
      end

      private

      def open_file(filename, flag = 'r')
        return if filename.nil?
        flag = 'wb' if @options[:unix_newlines] && flag == 'w'
        File.open(filename, flag)
      end

      def handle_load_error(err)
        dep = err.message.scan(/^no such file to load -- (.*)/)[0]
        raise err if @options[:trace] || dep.nil? || dep.empty?
        $stderr.puts <<MESSAGE
Required dependency #{dep} not found!
    Run "gem install #{dep}" to get it.
  Use --trace for backtrace.
MESSAGE
        exit 1
      end
    end

    # The `haml` executable.
    class Haml < Generic
      # @param args [Array<String>] The command-line arguments
      def initialize(args)
        super
        @options[:for_engine] = {}
        @options[:requires] = []
        @options[:load_paths] = []
      end

      # Tells optparse how to parse the arguments.
      #
      # @param opts [OptionParser]
      def set_opts(opts)
        super

        opts.banner = <<END
Usage: haml [options] [INPUT] [OUTPUT]

Description:
  Converts Haml files to HTML.

Options:
END

        opts.on('-c', '--check', "Just check syntax, don't evaluate.") do
          require 'stringio'
          @options[:check_syntax] = true
          @options[:output] = StringIO.new
        end

        opts.on('-t', '--style NAME',
                'Output style. Can be indented (default) or ugly.') do |name|
          @options[:for_engine][:ugly] = true if name.to_sym == :ugly
        end

        opts.on('-f', '--format NAME',
                'Output format. Can be xhtml (default), html4, or html5.') do |name|
          @options[:for_engine][:format] = name.to_sym
        end

        opts.on('-e', '--escape-html',
                'Escape HTML characters (like ampersands and angle brackets) by default.') do
          @options[:for_engine][:escape_html] = true
        end

        opts.on('-q', '--double-quote-attributes',
                'Set attribute wrapper to double-quotes (default is single).') do
          @options[:for_engine][:attr_wrapper] = '"'
        end

        opts.on('-r', '--require FILE', "Same as 'ruby -r'.") do |file|
          @options[:requires] << file
        end

        opts.on('-I', '--load-path PATH', "Same as 'ruby -I'.") do |path|
          @options[:load_paths] << path
        end

        unless ::Haml::Util.ruby1_8?
          opts.on('-E ex[:in]', 'Specify the default external and internal character encodings.') do |encoding|
            external, internal = encoding.split(':')
            Encoding.default_external = external if external && !external.empty?
            Encoding.default_internal = internal if internal && !internal.empty?
          end
        end

        opts.on('--debug', "Print out the precompiled Ruby source.") do
          @options[:debug] = true
        end
      end

      # Processes the options set by the command-line arguments,
      # and runs the Haml compiler appropriately.
      def process_result
        super
        @options[:for_engine][:filename] = @options[:filename]
        input = @options[:input]
        output = @options[:output]

        template = input.read()
        input.close() if input.is_a? File

        begin
          engine = ::Haml::Engine.new(template, @options[:for_engine])
          if @options[:check_syntax]
            puts "Syntax OK"
            return
          end

          @options[:load_paths].each {|p| $LOAD_PATH << p}
          @options[:requires].each {|f| require f}

          if @options[:debug]
            puts engine.precompiled
            puts '=' * 100
          end

          result = engine.to_html
        rescue Exception => e
          raise e if @options[:trace]

          case e
          when ::Haml::SyntaxError; raise "Syntax error on line #{get_line e}: #{e.message}"
          when ::Haml::Error;       raise "Haml error on line #{get_line e}: #{e.message}"
          else raise "Exception on line #{get_line e}: #{e.message}\n  Use --trace for backtrace."
          end
        end

        output.write(result)
        output.close() if output.is_a? File
      end
    end

    # The `html2haml` executable.
    class HTML2Haml < Generic
      # @param args [Array<String>] The command-line arguments
      def initialize(args)
        super
        @module_opts = {}
      end

      # Tells optparse how to parse the arguments.
      #
      # @param opts [OptionParser]
      def set_opts(opts)
        opts.banner = <<END
Usage: html2haml [options] [INPUT] [OUTPUT]

Description: Transforms an HTML file into corresponding Haml code.

Options:
END

        opts.on('-e', '--erb', 'Parse ERb tags.') do
          @module_opts[:erb] = true
        end

        opts.on('--no-erb', "Don't parse ERb tags.") do
          @options[:no_erb] = true
        end

        opts.on('-r', '--rhtml', 'Deprecated; same as --erb.') do
          @module_opts[:erb] = true
        end

        opts.on('--no-rhtml', "Deprecated; same as --no-erb.") do
          @options[:no_erb] = true
        end

        opts.on('-x', '--xhtml', 'Parse the input using the more strict XHTML parser.') do
          @module_opts[:xhtml] = true
        end

        super
      end

      # Processes the options set by the command-line arguments,
      # and runs the HTML compiler appropriately.
      def process_result
        super

        require 'haml/html'

        input = @options[:input]
        output = @options[:output]

        @module_opts[:erb] ||= input.respond_to?(:path) && input.path =~ /\.(rhtml|erb)$/
        @module_opts[:erb] &&= @options[:no_erb] != false

        output.write(::Haml::HTML.new(input, @module_opts).render)
      rescue ::Haml::Error => e
        raise "#{e.is_a?(::Haml::SyntaxError) ? "Syntax error" : "Error"} on line " +
          "#{get_line e}: #{e.message}"
      rescue LoadError => err
        handle_load_error(err)
      end
    end
<<<<<<< HEAD
=======

    # The `sass-convert` executable.
    class SassConvert < Generic
      # @param args [Array<String>] The command-line arguments
      def initialize(args)
        super
        require 'sass'
        @options[:for_tree] = {}
        @options[:for_engine] = {:cache => false, :read_cache => true}
      end

      # Tells optparse how to parse the arguments.
      #
      # @param opts [OptionParser]
      def set_opts(opts)
        opts.banner = <<END
Usage: sass-convert [options] [INPUT] [OUTPUT]

Description:
  Converts between CSS, Sass, and SCSS files.
  E.g. converts from SCSS to Sass,
  or converts from CSS to SCSS (adding appropriate nesting).

Options:
END

        opts.on('-F', '--from FORMAT',
          'The format to convert from. Can be css, scss, sass, less, or sass2.',
          'sass2 is the same as sass, but updates more old syntax to new.',
          'By default, this is inferred from the input filename.',
          'If there is none, defaults to css.') do |name|
          @options[:from] = name.downcase.to_sym
          unless [:css, :scss, :sass, :less, :sass2].include?(@options[:from])
            raise "Unknown format for sass-convert --from: #{name}"
          end
          try_less_note if @options[:from] == :less
        end

        opts.on('-T', '--to FORMAT',
          'The format to convert to. Can be scss or sass.',
          'By default, this is inferred from the output filename.',
          'If there is none, defaults to sass.') do |name|
          @options[:to] = name.downcase.to_sym
          unless [:scss, :sass].include?(@options[:to])
            raise "Unknown format for sass-convert --to: #{name}"
          end
        end

        opts.on('-R', '--recursive',
          'Convert all the files in a directory. Requires --from and --to.') do
          @options[:recursive] = true
        end

        opts.on('-i', '--in-place',
          'Convert a file to its own syntax.',
          'This can be used to update some deprecated syntax.') do
          @options[:in_place] = true
        end

        opts.on('--dasherize', 'Convert underscores to dashes') do
          @options[:for_tree][:dasherize] = true
        end

        opts.on('--old', 'Output the old-style ":prop val" property syntax.',
                         'Only meaningful when generating Sass.') do
          @options[:for_tree][:old] = true
        end

        opts.on('-C', '--no-cache', "Don't cache to sassc files.") do
          @options[:for_engine][:read_cache] = false
        end

        unless ::Haml::Util.ruby1_8?
          opts.on('-E encoding', 'Specify the default encoding for Sass and CSS files.') do |encoding|
            Encoding.default_external = encoding
          end
        end

        super
      end

      # Processes the options set by the command-line arguments,
      # and runs the CSS compiler appropriately.
      def process_result
        require 'sass'

        if @options[:recursive]
          process_directory
          return
        end

        super
        input = @options[:input]
        raise "Error: '#{input.path}' is a directory (did you mean to use --recursive?)" if File.directory?(input)
        output = @options[:output]
        output = input if @options[:in_place]
        process_file(input, output)
      end

      private

      def process_directory
        unless input = @options[:input] = @args.shift
          raise "Error: directory required when using --recursive."
        end

        output = @options[:output] = @args.shift
        raise "Error: --from required when using --recursive." unless @options[:from]
        raise "Error: --to required when using --recursive." unless @options[:to]
        raise "Error: '#{@options[:input]}' is not a directory" unless File.directory?(@options[:input])
        if @options[:output] && File.exists?(@options[:output]) && !File.directory?(@options[:output])
          raise "Error: '#{@options[:output]}' is not a directory"
        end
        @options[:output] ||= @options[:input]

        from = @options[:from]
        from = :sass if from == :sass2
        if @options[:to] == @options[:from] && !@options[:in_place]
          fmt = @options[:from]
          raise "Error: converting from #{fmt} to #{fmt} without --in-place"
        end

        ext = @options[:from]
        ext = :sass if ext == :sass2
        Dir.glob("#{@options[:input]}/**/*.#{ext}") do |f|
          output =
            if @options[:in_place]
              f
            elsif @options[:output]
              output_name = f.gsub(/\.(c|sa|sc|le)ss$/, ".#{@options[:to]}")
              output_name[0...@options[:input].size] = @options[:output]
              output_name
            else
              f.gsub(/\.(c|sa|sc|le)ss$/, ".#{@options[:to]}")
            end

          unless File.directory?(File.dirname(output))
            puts_action :directory, :green, File.dirname(output)
            FileUtils.mkdir_p(File.dirname(output))
          end
          puts_action :convert, :green, f
          if File.exists?(output)
            puts_action :overwrite, :yellow, output
          else
            puts_action :create, :green, output
          end

          input = open_file(f)
          output = @options[:in_place] ? input : open_file(output, "w")
          process_file(input, output)
        end
      end

      def process_file(input, output)
        if input.is_a?(File)
          @options[:from] ||=
            case input.path
            when /\.scss$/; :scss
            when /\.sass$/; :sass
            when /\.less$/; :less
            when /\.css$/; :css
            end
        elsif @options[:in_place]
          raise "Error: the --in-place option requires a filename."
        end

        if output.is_a?(File)
          @options[:to] ||=
            case output.path
            when /\.scss$/; :scss
            when /\.sass$/; :sass
            end
        end

        if @options[:from] == :sass2
          @options[:from] = :sass
          @options[:for_engine][:sass2] = true
        end

        @options[:from] ||= :css
        @options[:to] ||= :sass
        @options[:for_engine][:syntax] = @options[:from]

        out =
          ::Haml::Util.silence_haml_warnings do
            if @options[:from] == :css
              require 'sass/css'
              ::Sass::CSS.new(input.read, @options[:for_tree]).render(@options[:to])
            elsif @options[:from] == :less
              require 'sass/less'
              try_less_note
              input = input.read if input.is_a?(IO) && !input.is_a?(File) # Less is dumb
              Less::Engine.new(input).to_tree.to_sass_tree.send("to_#{@options[:to]}", @options[:for_tree])
            else
              if input.is_a?(File)
                ::Sass::Engine.for_file(input.path, @options[:for_engine])
              else
                ::Sass::Engine.new(input.read, @options[:for_engine])
              end.to_tree.send("to_#{@options[:to]}", @options[:for_tree])
            end
          end

        output = File.open(input.path, 'w') if @options[:in_place]
        output.write(out)
      rescue ::Sass::SyntaxError => e
        raise e if @options[:trace]
        file = " of #{e.sass_filename}" if e.sass_filename
        raise "Error on line #{e.sass_line}#{file}: #{e.message}\n  Use --trace for backtrace"
      rescue LoadError => err
        handle_load_error(err)
      end

      @@less_note_printed = false
      def try_less_note
        return if @@less_note_printed
        @@less_note_printed = true
        warn <<NOTE
* NOTE: Sass and Less are different languages, and they work differently.
* I'll do my best to translate, but some features -- especially mixins --
* should be checked by hand.
NOTE
      end
    end
>>>>>>> master
  end
end
