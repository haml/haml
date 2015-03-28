module Hamlit
  module Compilers
    module Dynamic
      def on_dynamic(exp)
        [:dynamic, "(#{exp}).to_s"]
      end
    end
  end
end
