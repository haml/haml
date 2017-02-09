require 'test_helper'

class TempleLineCounterTest < Haml::TestCase
  TESTED_TEMPLES = [
    [:multi,
     [:code, "foo"],
     [:static, "bar"],
     [:dynamic, "baz"],
    ],
    [:multi,
     [:code, "foo\nbar\nbaz"],
     [:static, "foo\nbar\nbaz"],
     [:dynamic, "foo\nbar\nbaz"],
    ],
    [:case,
     ["'a\nb', false", [:static, "hello\n"]],
     [:else, [:code, "raise 'error\n'"]],
    ],
    [:escape, true, [:dynamic, "foo\nbar"]],
    [:escape, :once, [:dynamic, "foo\nbar"]],
    [:escape, false, [:dynamic, "foo\nbar"]],
    [:escape, true, [:static, "foo\nbar"]],
    [:escape, :once, [:static, "foo\nbar"]],
    [:escape, false, [:dynamic, "foo\nbar"]],
  ]

  def test_count_lines
    TESTED_TEMPLES.each do |temple|
      code = Haml::TempleEngine.chain.inject(temple) do |exp, (symbol, filter)|
        case symbol
        when :Parser, :Compiler
          exp
        else
          filter.call(Haml::TempleEngine).call(exp)
        end
      end
      assert_equal code.count("\n"), Haml::TempleLineCounter.count_lines(temple)
    end
  end
end
