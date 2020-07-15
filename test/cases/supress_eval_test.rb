
require 'cases/test_base'

class SuppressEvalTest < TestBase

  def test_stop_eval
    assert_equal("", render("= 'Hello'", :suppress_eval => true))
    assert_equal("", render("- haml_concat 'foo'", :suppress_eval => true))
    assert_equal("<div id='foo' yes='no'>\n", render("#foo{:yes => 'no'}/", :suppress_eval => true))
    assert_equal("<div id='foo'>\n", render("#foo{:yes => 'no', :call => a_function() }/", :suppress_eval => true))
    assert_equal("<div>\n", render("%div[1]/", :suppress_eval => true))
    assert_equal("", render(":ruby\n  Kernel.puts 'hello'", :suppress_eval => true))
  end

  def test_static_hashes
    assert_equal("<a b='a =&gt; b'></a>\n", render("%a{:b => 'a => b'}", :suppress_eval => true))
    assert_equal("<a b='a, b'></a>\n", render("%a{:b => 'a, b'}", :suppress_eval => true))
    assert_equal("<a b='a\tb'></a>\n", render('%a{:b => "a\tb"}', :suppress_eval => true))
    assert_equal("<a b='a\#{foo}b'></a>\n", render('%a{:b => "a\\#{foo}b"}', :suppress_eval => true))
    assert_equal("<a b='#f00'></a>\n", render("%a{:b => '#f00'}", :suppress_eval => true))
  end

  def test_dynamic_hashes_with_suppress_eval
    assert_equal("<a></a>\n", render('%a{:b => "a #{1 + 1} b", :c => "d"}', :suppress_eval => true))
  end

end