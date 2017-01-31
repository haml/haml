# frozen_string_literal: true
module Haml
  class Generator
    include Temple::Mixins::CompiledDispatcher
    include Temple::Mixins::Options

    def call(exp)
      compile(exp)
    end

    def on_multi(*exp)
      exp.map { |e| compile(e) }.join('; ')
    end

    def on_code(exp)
      exp
    end
  end
end
