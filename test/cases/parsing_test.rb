
require 'cases/test_base'

class ParsingTest < TestBase
  def test_attrs_parsed_correctly
    assert_equal("<p foo,bar='baz, qux'></p>\n", render("%p{'foo,bar' => 'baz, qux'}"))
    assert_equal("<p escaped='quo4te'></p>\n", render("%p{ :escaped => \"quo\#{2 + 2}te\"}"))
  end

  def test_correct_parsing_with_brackets
    assert_equal("<p class='foo'>{tada} foo</p>\n", render("%p{:class => 'foo'} {tada} foo"))
    assert_equal("<p class='foo'>deep {nested { things }}</p>\n", render("%p{:class => 'foo'} deep {nested { things }}"))
    assert_equal("<p class='foo bar'>{a { d</p>\n", render("%p{{:class => 'foo'}, :class => 'bar'} {a { d"))
    assert_equal("<p foo='bar'>a}</p>\n", render("%p{:foo => 'bar'} a}"))

    foo = []
    foo[0] = Struct.new('Foo', :id).new
    assert_equal("<p class='struct_foo' id='struct_foo_new'>New User]</p>\n",
                 render("%p[foo[0]] New User]", :locals => {:foo => foo}))
    assert_equal("<p class='prefix_struct_foo' id='prefix_struct_foo_new'>New User]</p>\n",
                 render("%p[foo[0], :prefix] New User]", :locals => {:foo => foo}))

    foo[0].id = 1
    assert_equal("<p class='struct_foo' id='struct_foo_1'>New User]</p>\n",
                 render("%p[foo[0]] New User]", :locals => {:foo => foo}))
    assert_equal("<p class='prefix_struct_foo' id='prefix_struct_foo_1'>New User]</p>\n",
                 render("%p[foo[0], :prefix] New User]", :locals => {:foo => foo}))
  end

  def test_curly_brace
    assert_equal(<<HTML, render(<<HAML))
Foo { Bar
HTML
== Foo { Bar
HAML
  end
end