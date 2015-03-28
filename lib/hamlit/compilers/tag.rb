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

      def strip_newline(content)
        return content unless content.is_a?(Array) && content.first == :multi

        indexes = newline_indexes(content)
        return content if indexes.length < 2

        content = content.dup
        content.delete_at(indexes.last)
        content.delete_at(indexes.first)
        content
      end

      def newline_indexes(exps)
        indexes = []
        exps.each_with_index do |exp, index|
          indexes << index if exp == [:static, "\n"]
        end
        indexes
      end
    end
  end
end
