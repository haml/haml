module Haml
  # A module to count lines of expected code. This would be faster than actual code generation
  # and counting newlines in it.
  module TempleLineCounter
    class UnexpectedExpression < StandardError; end

    def self.count_lines(exp)
      type, *args = exp
      case type
      when :multi
        args.map { |a| count_lines(a) }.reduce(:+) || 0
      when :dynamic, :code
        args.first.count("\n")
      when :static
        0 # It has not real newline "\n" but escaped "\\n".
      else
        raise UnexpectedExpression.new("[HAML BUG] Unexpected Temple expression '#{type}' is given!")
      end
    end
  end
end
