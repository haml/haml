
require 'cases/test_base'

# Any tests primarily focused on either the #id .class syntax or the various merging and edge-cases related to them and attributes
# Related test files are the Attribute, HTML4, and HTML5 test cases
class CssIdentifierTest < TestBase

  def test_nil_id_with_syntactic_id
    assert_equal("<p id='foo'>nil</p>\n", render("%p#foo{:id => nil} nil"))
    assert_equal("<p id='foo_bar'>nil</p>\n", render("%p#foo{{:id => 'bar'}, :id => nil} nil"))
    assert_equal("<p id='foo_bar'>nil</p>\n", render("%p#foo{{:id => nil}, :id => 'bar'} nil"))
  end

  def test_nil_class_with_syntactic_class
    assert_equal("<p class='foo'>nil</p>\n", render("%p.foo{:class => nil} nil"))
    assert_equal("<p class='bar foo'>nil</p>\n", render("%p.bar.foo{:class => nil} nil"))
    assert_equal("<p class='foo bar'>nil</p>\n", render("%p.foo{{:class => 'bar'}, :class => nil} nil"))
    assert_equal("<p class='foo bar'>nil</p>\n", render("%p.foo{{:class => nil}, :class => 'bar'} nil"))
  end

  def test_colon_in_class_attr
    assert_equal("<p class='foo:bar'>\n", render("%p.foo:bar/"))
  end

  def test_colon_in_id_attr
    assert_equal("<p id='foo:bar'>\n", render("%p#foo:bar/"))
  end

  def test_class_attr_with_array
    assert_equal("<p class='a b'>foo</p>\n", render("%p{:class => %w[a b]} foo")) # basic
    assert_equal("<p class='css a b'>foo</p>\n", render("%p.css{:class => %w[a b]} foo")) # merge with css
    assert_equal("<p class='css b'>foo</p>\n", render("%p.css{:class => %w[b css]} foo")) # merge uniquely
    assert_equal("<p class='a b c d'>foo</p>\n", render("%p{:class => [%w[a b], %w[c d]]} foo")) # flatten
    assert_equal("<p class='a b'>foo</p>\n", render("%p{:class => [:a, :b] } foo")) # stringify
    assert_equal("<p>foo</p>\n", render("%p{:class => [nil, false] } foo")) # strip falsey
    assert_equal("<p class='a'>foo</p>\n", render("%p{:class => :a} foo")) # single stringify
    assert_equal("<p>foo</p>\n", render("%p{:class => false} foo")) # single falsey
    assert_equal("<p class='html a b'>foo</p>\n", render("%p(class='html'){:class => %w[a b]} foo")) # html attrs
  end

  def test_id_attr_with_array
    assert_equal("<p id='a_b'>foo</p>\n", render("%p{:id => %w[a b]} foo")) # basic
    assert_equal("<p id='css_a_b'>foo</p>\n", render("%p#css{:id => %w[a b]} foo")) # merge with css
    assert_equal("<p id='a_b_c_d'>foo</p>\n", render("%p{:id => [%w[a b], %w[c d]]} foo")) # flatten
    assert_equal("<p id='a_b'>foo</p>\n", render("%p{:id => [:a, :b] } foo")) # stringify
    assert_equal("<p>foo</p>\n", render("%p{:id => [nil, false] } foo")) # strip falsey
    assert_equal("<p id='a'>foo</p>\n", render("%p{:id => :a} foo")) # single stringify
    assert_equal("<p>foo</p>\n", render("%p{:id => false} foo")) # single falsey
    assert_equal("<p id='html_a_b'>foo</p>\n", render("%p(id='html'){:id => %w[a b]} foo")) # html attrs
  end

  def test_css_id_as_attribute_should_be_appended_with_underscore
    assert_equal("<div id='my_id_1'></div>", render("#my_id{:id => '1'}").chomp)
    assert_equal("<div id='my_id_1'></div>", render("#my_id{:id => 1}").chomp)
  end
end