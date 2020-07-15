
require 'cases/test_base'

class BindingTest < TestBase

  def test_render_should_accept_a_binding_as_scope
    string = "This is a string!".dup
    string.instance_variable_set(:@var, "Instance variable")
    b = string.instance_eval do
      var = "Local variable"
      # Silence unavoidable warning; Ruby doesn't know we're going to use this
      # later.
      nil if var
      binding
    end

    assert_equal("<p>THIS IS A STRING!</p>\n<p>Instance variable</p>\n<p>Local variable</p>\n",
                 render("%p= upcase\n%p= @var\n%p= var", :scope => b))
  end

  def test_yield_should_work_with_binding
    assert_equal("12\nFOO\n", render("= yield\n= upcase", :scope => "foo".dup.instance_eval{binding}) { 12 })
  end

  def test_yield_should_work_with_def_method
    s = "foo".dup
    engine("= yield\n= upcase").def_method(s, :render)
    assert_equal("12\nFOO\n", s.render { 12 })
  end

  def test_def_method_with_module
    engine("= yield\n= upcase").def_method(String, :render_haml)
    assert_equal("12\nFOO\n", "foo".dup.render_haml { 12 })
  end

  def test_def_method_locals
    obj = Object.new
    engine("%p= foo\n.bar{:baz => baz}= boom").def_method(obj, :render, :foo, :baz, :boom)
    assert_equal("<p>1</p>\n<div baz='2' class='bar'>3</div>\n", obj.render(:foo => 1, :baz => 2, :boom => 3))
  end

  def test_render_proc_locals
    proc = engine("%p= foo\n.bar{:baz => baz}= boom").render_proc(Object.new, :foo, :baz, :boom)
    assert_equal("<p>1</p>\n<div baz='2' class='bar'>3</div>\n", proc[:foo => 1, :baz => 2, :boom => 3])
  end

  def test_render_proc_with_binding
    assert_equal("FOO\n", engine("= upcase").render_proc("foo".dup.instance_eval{binding}).call)
  end

  def test_interpolates_instance_vars_in_attribute_values
    scope = Object.new
    scope.instance_variable_set :@foo, 'bar'
    assert_equal("<a b='a bar b'></a>\n", render('%a{:b => "a #@foo b"}', :scope => scope))
  end

  def test_interpolates_global_vars_in_attribute_values
    # make sure the value isn't just interpolated in during template compilation
    engine = Haml::Engine.new('%a{:b => "a #$global_var_for_testing b"}')
    $global_var_for_testing = 'bar'
    assert_equal("<a b='a bar b'></a>\n", engine.to_html)
  ensure
    $global_var_for_testing = nil
  end

  def test_attr_hashes_not_modified
    hash = {:color => 'red'}
    assert_equal(<<HTML, render(<<HAML, :locals => {:hash => hash}))
<div color='red'></div>
<div class='special' color='red'></div>
<div color='red'></div>
HTML
%div{hash}
.special{hash}
%div{hash}
HAML
    assert_equal(hash, {:color => 'red'})
  end

  def test_local_assigns_dont_modify_class
    assert_equal("bar\n", render("= foo", :locals => {:foo => 'bar'}))
    assert_nil(defined?(foo))
  end
end