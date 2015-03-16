module Hamlit
  module Filters
    class Css
      def compile(exp)
        [:html, :tag, 'style', [:html, :attrs], exp]
      end
    end
  end
end
