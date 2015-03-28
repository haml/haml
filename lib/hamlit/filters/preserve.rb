module Hamlit
  module Filters
    class Preserve
      def compile(lines)
        [:multi, [:haml, :text, lines.join('&#x000A;')]]
      end
    end
  end
end
