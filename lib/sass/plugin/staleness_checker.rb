module Sass
  module Plugin
    # The class handles `.s[ca]ss` file staleness checks via their mtime timestamps.
    #
    # To speed things up two level of caches are employed:
    #
    # * A class-level dependency cache which stores @import paths for each file.
    #   This is a long-lived cache that is reused by every StalenessChecker instance.
    # * Three short-lived instance-level caches, one for file mtimes,
    #   one for whether a file is stale during this particular run.
    #   and one for the parse tree for a file.
    #   These are only used by a single StalenessChecker instance.
    #
    # Usage:
    #
    # * For a one-off staleness check of a single `.s[ca]ss` file,
    #   the class-level {stylesheet_needs_update?} method
    #   should be used.
    # * For a series of staleness checks (e.g. checking all files for staleness)
    #   a StalenessChecker instance should be created,
    #   and the instance-level \{#stylesheet\_needs\_update?} method should be used.
    #   the caches should make the whole process significantly faster.
    #   *WARNING*: It is important not to retain the instance for too long,
    #   as its instance-level caches are never explicitly expired.
    class StalenessChecker
      DELETED             = 1.0/0.0 # positive Infinity
      @dependencies_cache = {}

      class << self
        # TODO: attach this to a compiler instance.
        # @private
        attr_accessor :dependencies_cache
      end

      # Creates a new StalenessChecker
      # for checking the staleness of several stylesheets at once.
      #
      # @param options [{Symbol => Object}]
      #   See {file:SASS_REFERENCE.md#sass_options the Sass options documentation}.
      def initialize(options)
        @dependencies = self.class.dependencies_cache

        # Entries in the following instance-level caches are never explicitly expired.
        # Instead they are supposed to automaticaly go out of scope when a series of staleness checks
        # (this instance of StalenessChecker was created for) is finished.
        @mtimes, @dependencies_stale, @parse_trees = {}, {}, {}
        @options = Sass::Engine.normalize_options(options)
      end

      # Returns whether or not a given CSS file is out of date
      # and needs to be regenerated.
      #
      # @param css_file [String] The location of the CSS file to check.
      # @param template_file [String] The location of the Sass or SCSS template
      #   that is compiled to `css_file`.
      def stylesheet_needs_update?(css_file, template_file)
        template_file = File.expand_path(template_file)
        begin
          css_mtime = File.mtime(css_file).to_i
        rescue Errno::ENOENT
          return true
        end

        dependency_updated?(css_mtime).call(
          template_file, @options[:filesystem_importer].new("."))
      end

      # Returns whether or not a given CSS file is out of date
      # and needs to be regenerated.
      #
      # The distinction between this method and the instance-level \{#stylesheet\_needs\_update?}
      # is that the instance method preserves mtime and stale-dependency caches,
      # so it's better to use when checking multiple stylesheets at once.
      #
      # @param css_file [String] The location of the CSS file to check.
      # @param template_file [String] The location of the Sass or SCSS template
      #   that is compiled to `css_file`.
      def self.stylesheet_needs_update?(css_file, template_file)
        new(Plugin.engine_options).stylesheet_needs_update?(css_file, template_file)
      end

      private

      def dependencies_stale?(uri, importer, css_mtime)
        timestamps = @dependencies_stale[[uri, importer]] ||= {}
        timestamps.each_pair do |checked_css_mtime, is_stale|
          if checked_css_mtime <= css_mtime && !is_stale
            return false
          elsif checked_css_mtime > css_mtime && is_stale
            return true
          end
        end
        timestamps[css_mtime] = dependencies(uri, importer).any?(&dependency_updated?(css_mtime))
      rescue Sass::SyntaxError
        # If there's an error finding dependencies, default to recompiling.
        true
      end

      def mtime(uri, importer)
        @mtimes[[uri, importer]] ||=
          begin
            mtime = importer.mtime(uri, @options)
            if mtime.nil?
              @dependencies.delete([uri, importer])
              DELETED
            else
              mtime.to_i
            end
          end
      end

      def dependencies(uri, importer)
        stored_mtime, dependencies = @dependencies[[uri, importer]]

        if !stored_mtime || stored_mtime < mtime(uri, importer)
          dependencies = compute_dependencies(uri, importer)
          @dependencies[[uri, importer]] = [mtime(uri, importer), dependencies]
        end

        dependencies
      end

      def dependency_updated?(css_mtime)
        lambda do |uri, importer|
          mtime(uri, importer) > css_mtime ||
            dependencies_stale?(uri, importer, css_mtime)
        end
      end

      def compute_dependencies(uri, importer)
        tree(uri, importer).grep(Tree::ImportNode) do |n|
          next if n.css_import?
          file = n.imported_file
          key = [file.options[:filename], file.options[:importer]]
          @parse_trees[key] = file.to_tree
          key
        end.compact
      end

      def tree(uri, importer)
        @parse_trees[[uri, importer]] ||= importer.find(uri, @options).to_tree
      end
    end
  end
end
