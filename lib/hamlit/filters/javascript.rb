module Hamlit
  module Filters
    class Javascript
      def compile(exp)
        [:html, :tag, 'script', [:html, :attrs], [:html, :js, exp]]
      end
    end
  end
end
