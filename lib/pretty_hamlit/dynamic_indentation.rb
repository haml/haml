module PrettyHamlit
  class DynamicIndentation
    class << self
      def indent_with(indent_level, &block)
        text = capture(&block)
        insert_indent(text, indent_level)
      end

      def inline_or_expand(indent_level, &block)
        text = capture(&block)
        return text unless text.include?("\n")

        indent_space(indent_level) <<
          insert_indent(text, indent_level) <<
          indent_space(indent_level - 1)
      end

      private

      def indent_space(indent_level)
        "\n" << '  ' * [indent_level, 0].max
      end

      def insert_indent(text, indent_level)
        text.gsub("\n", indent_space(indent_level))
      end

      def capture(&block)
        block.call([]).compact.join.rstrip
      end
    end
  end
end
