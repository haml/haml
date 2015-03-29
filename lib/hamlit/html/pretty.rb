require 'hamlit/concerns/deprecation'
require 'temple/html/pretty'

# NOTE: This does not work. Actually on_static is just a workaround.
# This should be totally rewritten. Because pretty mode is not used
# on production and not so important, it is not done for now.
module Hamlit
  module HTML
    class Pretty < Temple::HTML::Pretty
      include Concerns::Deprecation

      def call(exp)
        result = super(exp)
        result << [:static, "\n"] if @added_newline
        result
      end

      def on_static(exp)
        if exp == "\n"
          @added_newline = true
          [:static, '']
        else
          [:static, exp]
        end
      end

      def on_html_tag(name, attrs, content = nil)
        if content.is_a?(Array) && content.first != :multi
          return parse_oneline_tag(name, attrs, content)
        end

        super
      end

      private

      def parse_oneline_tag(name, attrs, content)
        name = name.to_s
        closed = !content || (empty_exp?(content) && (@format == :xml || options[:autoclose].include?(name)))
        result = [:multi, [:static, "<#{name}"], compile(attrs)]
        result << [:static, (closed && @format != :html ? ' /' : '') + '>']
        result << compile(content) if content
        result << [:static, "</#{name}>"] if !closed
        result
      end
    end
  end
end
