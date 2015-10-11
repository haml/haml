module Hamlit
  class DoctypeCompiler
    def initialize(format)
      @format = format
    end

    def compile(node)
      [:html, :doctype, node.value[:type]]
    end
  end
end
