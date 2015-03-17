module Hamlit
  module Filters
    class Ruby
      def compile(exp)
        [:multi, [:code, exp.join("\n")], [:newline]]
      end
    end
  end
end
