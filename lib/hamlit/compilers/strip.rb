module Hamlit
  module Compilers
    module Strip
      def on_haml_strip(*exps)
        stripped = strip_newline(exps)
        on_multi(*stripped)
      end

      private

      def strip_newline(content)
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
