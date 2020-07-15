
require 'cases/test_base'

class InterpolationTest < TestBase
  def test_interpolation
    assert_equal("<p>Hello World</p>\n", render('%p Hello #{who}', locals: {who: 'World'}, escape_html: false))
    assert_equal("<p>\nHello World\n</p>\n", render("%p\n  Hello \#{who}", locals: {who: 'World'}, escape_html: false))
    assert_equal("<p>Hello World</p>\n", render('%p Hello #{who}', locals: {who: 'World'}, escape_html: true))
    assert_equal("<p>\nHello World\n</p>\n", render("%p\n  Hello \#{who}", locals: {who: 'World'}, escape_html: true))
  end

  def test_interpolation_with_instance_var
    scope = Object.new
    scope.instance_variable_set(:@who, 'World')

    assert_equal("<p>Hello World</p>\n", render('%p Hello #@who', scope: scope, escape_html: false))
    assert_equal("<p>\nHello World\n</p>\n", render("%p\n  Hello \#@who", scope: scope, escape_html: false))
    assert_equal("<p>Hello World</p>\n", render('%p Hello #@who', scope: scope, escape_html: true))
    assert_equal("<p>\nHello World\n</p>\n", render("%p\n  Hello \#@who", scope: scope, escape_html: true))
  end

  def test_interpolation_with_global
    $global_var_for_testing = 'World'

    assert_equal("<p>Hello World</p>\n", render('%p Hello #$global_var_for_testing', escape_html: false))
    assert_equal("<p>\nHello World\n</p>\n", render("%p\n  Hello \#$global_var_for_testing", escape_html: false))
    assert_equal("<p>Hello World</p>\n", render('%p Hello #$global_var_for_testing', escape_html: true))
    assert_equal("<p>\nHello World\n</p>\n", render("%p\n  Hello \#$global_var_for_testing", escape_html: true))
  ensure
    $global_var_for_testing = nil
  end

  def test_interpolation_in_the_middle_of_a_string
    assert_equal("\"title 'Title'. \"\n",
                 render("\"title '\#{\"Title\"}'. \""))
  end

  def test_interpolation_with_instance_var_in_the_middle_of_a_string
    scope = Object.new
    scope.instance_variable_set(:@title, 'Title')

    assert_equal("\"title 'Title'. \"\n",
                 render("\"title '\#@title'. \"", :scope => scope))
  end

  def test_interpolation_with_global_in_the_middle_of_a_string
    $global_var_for_testing = 'Title'

    assert_equal("\"title 'Title'. \"\n",
                 render("\"title '\#$global_var_for_testing'. \""))
  ensure
    $global_var_for_testing = nil
  end

  def test_interpolation_at_the_beginning_of_a_line
    assert_equal("<p>2</p>\n", render('%p #{1 + 1}'))
    assert_equal("<p>\n2\n</p>\n", render("%p\n  \#{1 + 1}"))
  end

  def test_interpolation_with_instance_var_at_the_beginning_of_a_line
    scope = Object.new
    scope.instance_variable_set(:@foo, 2)

    assert_equal("<p>2</p>\n", render('%p #@foo', :scope => scope))
    assert_equal("<p>\n2\n</p>\n", render("%p\n  \#@foo", :scope => scope))
  end

  def test_interpolation_with_global_at_the_beginning_of_a_line
    $global_var_for_testing = 2

    assert_equal("<p>2</p>\n", render('%p #$global_var_for_testing'))
    assert_equal("<p>\n2\n</p>\n", render("%p\n  \#$global_var_for_testing"))
  ensure
    $global_var_for_testing = nil
  end

  def test_escaped_interpolation
    assert_equal("<p>Foo &amp; Bar & Baz</p>\n", render('%p& Foo #{"&"} Bar & Baz'))
  end
end