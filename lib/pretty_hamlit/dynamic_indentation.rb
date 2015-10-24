module PrettyHamlit
  class DynamicIndentation
    class << self
      def indent_with(indent_level)
        indent = "\n" << '  ' * indent_level
        text = yield('')
        text.gsub("\n", indent)
      end
    end
  end
end
