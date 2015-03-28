module Hamlit
  module Filters
    class Plain
      def compile(lines)
        ast = [:multi]
        lines.each_with_index do |line, index|
          ast << [:static, "\n"] if index > 0
          ast << [:haml, :text, line]
        end
        ast
      end
    end
  end
end
