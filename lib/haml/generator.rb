module Haml
  class Generator
    include Temple::Mixins::CompiledDispatcher
    include Temple::Mixins::Options

    def call(exp)
      compile(exp)
    end

    def on_code(exp)
      exp
    end
  end
end
