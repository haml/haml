
require 'cases/test_base'

class FilterTest < TestBase
  def test_flexible_tabulation
    assert_equal("<p>\nfoo\n</p>\n<q>\nbar\n<a>\nbaz\n</a>\n</q>\n",
                 render("%p\n foo\n%q\n bar\n %a\n  baz"))
    assert_equal("<p>\nfoo\n</p>\n<q>\nbar\n<a>\nbaz\n</a>\n</q>\n",
                 render("%p\n\tfoo\n%q\n\tbar\n\t%a\n\t\tbaz"))
    assert_equal("<p>\n    \t \t bar\n baz\n</p>\n",
                 render("%p\n  :plain\n        \t \t bar\n     baz"))
  end


  def test_multiline_with_colon_after_filter
    assert_equal(<<HTML, render(<<HAML))
Foo
Bar
HTML
:plain
  Foo
= { :a => "Bar",      |
    :b => "Baz" }[:a] |
HAML
    assert_equal(<<HTML, render(<<HAML))

Bar
HTML
:plain
= { :a => "Bar",      |
    :b => "Baz" }[:a] |
HAML
  end

  def test_multiline_in_filter
    assert_equal(<<HTML, render(<<HAML))
Foo |
Bar |
Baz
HTML
:plain
  Foo |
  Bar |
  Baz
HAML
  end
end