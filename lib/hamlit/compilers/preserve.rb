module Hamlit
  module Compilers
    module Preserve
      def on_haml_preserve(code)
        code = "Hamlit::Helpers.find_and_preserve(#{code})"
        [:dynamic, code]
      end
    end
  end
end
