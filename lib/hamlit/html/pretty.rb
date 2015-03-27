require 'hamlit/concerns/deprecation'
require 'temple/html/pretty'

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
    end
  end
end
