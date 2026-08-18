# frozen_string_literal: true
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
      when :case
        arg, *cases = args
        arg.count("\n") + cases.map do |cond, e|
          (cond == :else ? 0 : cond.count("\n")) + count_lines(e)
        end.reduce(:+)
      when :escape, :fescape
        count_lines(args[1])
      when :html
        count_html_lines(args)
      when :newline
        1
      else
        raise UnexpectedExpression.new("[HAML BUG] Unexpected Temple expression '#{type}' is given!")
      end
    end

    def self.count_html_lines(args)
      case args[0]
      when :attrs
        args.drop(1).sum { |a| count_lines(a) }
      when :attr
        count_lines(args[2])
      else
        raise UnexpectedExpression.new("[HAML BUG] Unexpected Temple expression 'html #{args[0]}' is given!")
      end
    end
    private_class_method :count_html_lines
  end
end
