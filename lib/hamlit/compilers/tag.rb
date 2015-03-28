require 'hamlit/concerns/strippable'
require 'hamlit/helpers'

module Hamlit
  module Compilers
    module Tag
      def on_haml_tag(name, attrs, content = nil)
        if Helpers::DEFAULT_PRESERVE_TAGS.include?(name)
          content = strip_newline(content)
        end
        on_html_tag(name, attrs, content)
      end

      private

      def strip_multi(content)
        return content unless content.is_a?(Array) && content.first == :multi
        strip_newline(content)
      end
    end
  end
end
