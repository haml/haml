require 'cases/test_base'

class RubyMultilineTest < TestBase
  def test_escaped_loud_ruby_multiline
    assert_equal(<<HTML, render(<<HAML))
bar&lt;, baz, bang
<p>foo</p>
<p>bar</p>
HTML
&= ["bar<",
    "baz",
    "bang"].join(", ")
%p foo
%p bar
HAML
  end

  def test_unescaped_loud_ruby_multiline
    assert_equal(<<HTML, render(<<HAML, :escape_html => true))
bar<, baz, bang
<p>foo</p>
<p>bar</p>
HTML
!= ["bar<",
    "baz",
    "bang"].join(", ")
%p foo
%p bar
HAML
  end

  def test_flattened_loud_ruby_multiline
    assert_equal(<<HTML, render(<<HAML))
<pre>bar&#x000A;baz&#x000A;bang</pre>
<p>foo</p>
<p>bar</p>
HTML
~ "<pre>" + ["bar",
             "baz",
             "bang"].join("\\n") + "</pre>"
%p foo
%p bar
HAML
  end

  def test_loud_ruby_multiline_with_block
    assert_equal(<<HTML, render(<<HAML))
#{%w[far faz fang]}<p>foo</p>
<p>bar</p>
HTML
= ["bar",
   "baz",
   "bang"].map do |str|
  - str.gsub("ba",
             "fa")
%p foo
%p bar
HAML
  end

  def test_silent_ruby_multiline_with_block
    assert_equal(<<HTML, render(<<HAML))
far
faz
fang
<p>foo</p>
<p>bar</p>
HTML
- ["bar",
   "baz",
   "bang"].map do |str|
  = str.gsub("ba",
             "fa")
%p foo
%p bar
HAML
  end

  def test_ruby_multiline_in_tag
    assert_equal(<<HTML, render(<<HAML))
<p>foo, bar, baz</p>
<p>foo</p>
<p>bar</p>
HTML
%p= ["foo",
     "bar",
     "baz"].join(", ")
%p foo
%p bar
HAML
  end

  def test_escaped_ruby_multiline_in_tag
    assert_equal(<<HTML, render(<<HAML))
<p>foo&lt;, bar, baz</p>
<p>foo</p>
<p>bar</p>
HTML
%p&= ["foo<",
      "bar",
      "baz"].join(", ")
%p foo
%p bar
HAML
  end

  def test_unescaped_ruby_multiline_in_tag
    assert_equal(<<HTML, render(<<HAML, :escape_html => true))
<p>foo<, bar, baz</p>
<p>foo</p>
<p>bar</p>
HTML
%p!= ["foo<",
      "bar",
      "baz"].join(", ")
%p foo
%p bar
HAML
  end

  def test_ruby_multiline_with_normal_multiline
    assert_equal(<<HTML, render(<<HAML))
foobarbar, baz, bang
<p>foo</p>
<p>bar</p>
HTML
= "foo" + |
  "bar" + |
  ["bar", |
   "baz",
   "bang"].join(", ")
%p foo
%p bar
HAML
  end

  def test_ruby_multiline_after_filter
    assert_equal(<<HTML, render(<<HAML))
foo
bar
bar, baz, bang
<p>foo</p>
<p>bar</p>
HTML
:plain
  foo
  bar
= ["bar",
   "baz",
   "bang"].join(", ")
%p foo
%p bar
HAML
  end

  def test_silent_ruby_multiline
    assert_equal(<<HTML, render(<<HAML))
bar, baz, bang
<p>foo</p>
HTML
- foo = ["bar",
         "baz",
         "bang"]
= foo.join(", ")
%p foo
HAML
  end

  def test_loud_ruby_multiline
    assert_equal(<<HTML, render(<<HAML))
bar, baz, bang
<p>foo</p>
<p>bar</p>
HTML
= ["bar",
   "baz",
   "bang"].join(", ")
%p foo
%p bar
HAML
  end

  def test_ruby_multiline_with_punctuated_methods_is_continuation
    assert_equal(<<HTML, render(<<HAML))
bar, , true, bang
<p>foo</p>
<p>bar</p>
HTML
= ["bar",
   "  ".strip,
   "".empty?,
   "bang"].join(", ")
%p foo
%p bar
HAML
  end
end
