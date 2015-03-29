module Hamlit
  class SyntaxError < StandardError
  end

  class CompileError < StandardError
  end

  module Concerns
    module Error
      # Template engine must raise Exception on runtime to
      # show template's error backtrace.
      def syntax_error(message)
        code = %Q{raise Hamlit::SyntaxError.new(%q{#{message}})}
        [:code, code]
      end

      def assert_scan!(scanner, regexp)
        unless scanner.scan(regexp)
          raise CompileError.new("Expected to scan #{regexp} but got nil")
        end
      end
    end
  end
end
