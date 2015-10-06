module Hamlit
  class Compiler
    def initialize(options = {})
      @options = options
    end

    def call(template)
      [:multi, [:static, 'Hamlit']]
    end
  end
end
