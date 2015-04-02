module Hamlit
  class SyntaxError < StandardError; end
  class CompileError < StandardError; end

  module Concerns
    module Error
      # Template engine should raise Exception on runtime to
      # show template's error backtrace.
      def syntax_error(message)
        code = %Q{raise Hamlit::SyntaxError.new(%q{#{message}})}
        [:code, code]
      end

      def syntax_error!(message)
        raise Hamlit::SyntaxError.new(message)
      end

      def copmile_error!(message)
        raise CompileError.new(message)
      end

      def assert_scan!(scanner, regexp)
        result = scanner.scan(regexp)
        unless result
          raise CompileError.new("Expected to scan #{regexp} but got nil")
        end
        result
      end
    end
  end
end
