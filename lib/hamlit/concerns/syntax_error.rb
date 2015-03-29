module Hamlit
  class SyntaxError < StandardError
    def initialize(message)
      super(message)
    end
  end

  module Concerns
    module SyntaxError
      # Template engine must raise Exception on runtime to
      # show template's error backtrace.
      def syntax_error(message)
        code = %Q{raise Hamlit::SyntaxError.new(%q{#{message}})}
        [:code, code]
      end
    end
  end
end
