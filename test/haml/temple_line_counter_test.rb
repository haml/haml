# frozen_string_literal: true

require_relative '../test_helper'

describe Haml::TempleLineCounter do
  def count_lines(exp)
    Haml::TempleLineCounter.count_lines(exp)
  end

  it 'counts the code inside an fescape like an escape' do
    assert_equal 1, count_lines([:fescape, true, [:dynamic, "a\nb"]])
    assert_equal 0, count_lines([:fescape, true, [:static, "a\\nb"]])
  end

  it 'counts every child of html attrs' do
    attrs = [:html, :attrs,
             [:html, :attr, 'a', [:fescape, true, [:dynamic, "x\ny"]]],
             [:html, :attr, 'b', [:multi]],
             [:static, ' c="1"'],
             [:dynamic, "p\nq\nr"],
             [:case, "(v = (d\ne))", ['true', [:html, :attr, 'd', [:multi]]], [:else, [:multi]]],
             [:newline]]
    assert_equal 5, count_lines(attrs)
  end

  it 'counts the value of an html attr, not its name' do
    assert_equal 2, count_lines([:html, :attr, "a\nb", [:dynamic, "x\ny\nz"]])
  end

  it 'refuses an html expression it does not know' do
    assert_raises(Haml::TempleLineCounter::UnexpectedExpression) do
      count_lines([:html, :tag, 'p', [:html, :attrs], [:multi]])
    end
  end
end
