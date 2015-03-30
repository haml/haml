require 'hamlit/concerns/included'
require 'hamlit/concerns/registerable'
require 'hamlit/filters/css'
require 'hamlit/filters/erb'
require 'hamlit/filters/escaped'
require 'hamlit/filters/javascript'
require 'hamlit/filters/less'
require 'hamlit/filters/plain'
require 'hamlit/filters/preserve'
require 'hamlit/filters/ruby'
require 'hamlit/filters/sass'
require 'hamlit/filters/markdown'
require 'hamlit/filters/scss'

module Hamlit
  module Compilers
    module Filter
      extend Concerns::Included

      included do
        extend Concerns::Registerable

        define_options :format

        register :css,        Filters::Css
        register :erb,        Filters::Erb
        register :escaped,    Filters::Escaped
        register :javascript, Filters::Javascript
        register :less,       Filters::Less
        register :markdown,   Filters::Markdown
        register :plain,      Filters::Plain
        register :preserve,   Filters::Preserve
        register :ruby,       Filters::Ruby
        register :sass,       Filters::Sass
        register :scss,       Filters::Scss
      end

      def on_haml_filter(name, lines)
        ast = compile_filter(name, lines)
        compile(ast)
      end

      private

      def compile_filter(name, exp)
        self.class.find(name).new(options).compile(exp)
      end
    end
  end
end
