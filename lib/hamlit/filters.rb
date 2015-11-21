require 'hamlit/filters/base'
require 'hamlit/filters/text_base'
require 'hamlit/filters/tilt_base'
require 'hamlit/filters/coffee'
require 'hamlit/filters/css'
require 'hamlit/filters/erb'
require 'hamlit/filters/escaped'
require 'hamlit/filters/javascript'
require 'hamlit/filters/less'
require 'hamlit/filters/markdown'
require 'hamlit/filters/plain'
require 'hamlit/filters/preserve'
require 'hamlit/filters/ruby'
require 'hamlit/filters/sass'
require 'hamlit/filters/scss'

module Hamlit
  class Filters
    @registered = {}

    class << self
      attr_reader :registered

      private

      def register(name, compiler)
        registered[name] = compiler
      end
    end

    register :coffee,       Coffee
    register :coffeescript, Coffee
    register :css,          Css
    register :erb,          Erb
    register :escaped,      Escaped
    register :javascript,   Javascript
    register :less,         Less
    register :markdown,     Markdown
    register :plain,        Plain
    register :preserve,     Preserve
    register :ruby,         Ruby
    register :sass,         Sass
    register :scss,         Scss

    def initialize(options = {})
      @options = options
      @compilers = {}
    end

    def compile(node)
      node.value[:text] ||= ''
      find_compiler(node).compile(node)
    end

    private

    def find_compiler(node)
      name = node.value[:name].to_sym
      compiler = Filters.registered[name]
      raise FilterNotFound.new("FilterCompiler for '#{name}' was not found", node.line.to_i - 1) unless compiler

      @compilers[name] ||= compiler.new(@options)
    end
  end
end
