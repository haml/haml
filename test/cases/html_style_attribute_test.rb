
require 'cases/test_base'

class HtmlStyleAttributeTest < TestBase

  def test_basic_new_attributes
    assert_equal("<a>bar</a>\n", render("%a() bar"))
    assert_equal("<a href='foo'>bar</a>\n", render("%a(href='foo') bar"))
    assert_equal("<a b='c' c='d' d='e'>baz</a>\n", render(%q{%a(b="c" c='d' d="e") baz}))
  end

  def test_new_attribute_ids
    assert_equal("<div id='foo_bar'></div>\n", render("#foo(id='bar')"))
    assert_equal("<div id='foo_baz_bar'></div>\n", render("#foo{:id => 'bar'}(id='baz')"))
    assert_equal("<div id='foo_baz_bar'></div>\n", render("#foo(id='baz'){:id => 'bar'}"))
  end

  def test_new_attribute_classes
    assert_equal("<div class='foo bar'></div>\n", render(".foo(class='bar')"))
    assert_equal("<div class='foo baz bar'></div>\n", render(".foo{:class => 'bar'}(class='baz')"))
    assert_equal("<div class='foo moo baz bar alpha'></div>\n", render(".foo.moo{:class => ['bar', 'alpha']}(class='baz')"))
  end

  def test_dynamic_new_attributes
    assert_equal("<a href='12'>bar</a>\n", render("%a(href=foo) bar", :locals => {:foo => 12}))
    assert_equal("<a b='12' c='13' d='14'>bar</a>\n", render("%a(b=b c='13' d=d) bar", :locals => {:b => 12, :d => 14}))
  end

  def test_new_attribute_interpolation
    assert_equal("<a href='12'>bar</a>\n", render('%a(href="1#{1 + 1}") bar'))
    assert_equal("<a href='2: 2, 3: 3'>bar</a>\n", render(%q{%a(href='2: #{1 + 1}, 3: #{foo}') bar}, :locals => {:foo => 3}))
    assert_equal(%Q{<a href='1\#{1 + 1}'>bar</a>\n}, render('%a(href="1\#{1 + 1}") bar'))
  end

  def test_truthy_new_attributes
    assert_equal("<a href='href'>bar</a>\n", render("%a(href) bar", :format => :xhtml))
    assert_equal("<a bar='baz' href>bar</a>\n", render("%a(href bar='baz') bar", :format => :html5))
    assert_equal("<a href>bar</a>\n", render("%a(href=true) bar"))
    assert_equal("<a>bar</a>\n", render("%a(href=false) bar"))
  end

  def test_new_attribute_parsing
    assert_equal("<a a2='b2'>bar</a>\n", render("%a(a2=b2) bar", :locals => {:b2 => 'b2'}))
    assert_equal(%Q{<a a='foo&quot;bar'>bar</a>\n}, render(%q{%a(a="#{'foo"bar'}") bar})) #'
    assert_equal(%Q{<a a='foo&#39;bar'>bar</a>\n}, render(%q{%a(a="#{"foo'bar"}") bar})) #'
    assert_equal(%Q{<a a='foo&quot;bar'>bar</a>\n}, render(%q{%a(a='foo"bar') bar}))
    assert_equal(%Q{<a a='foo&#39;bar'>bar</a>\n}, render(%q{%a(a="foo'bar") bar}))
    assert_equal("<a a:b='foo'>bar</a>\n", render("%a(a:b='foo') bar"))
    assert_equal("<a a='foo' b='bar'>bar</a>\n", render("%a(a = 'foo' b = 'bar') bar"))
    assert_equal("<a a='foo' b='bar'>bar</a>\n", render("%a(a = foo b = bar) bar", :locals => {:foo => 'foo', :bar => 'bar'}))
    assert_equal("<a a='foo'>(b='bar')</a>\n", render("%a(a='foo')(b='bar')"))
    assert_equal("<a a='foo)bar'>baz</a>\n", render("%a(a='foo)bar') baz"))
    assert_equal("<a a='foo'>baz</a>\n", render("%a( a = 'foo' ) baz"))
  end

  def test_new_attribute_escaping
    assert_equal(%Q{<a a='foo &quot; bar'>bar</a>\n}, render(%q{%a(a="foo \" bar") bar}))
    assert_equal(%Q{<a a='foo \\&quot; bar'>bar</a>\n}, render(%q{%a(a="foo \\\\\" bar") bar}))

    assert_equal(%Q{<a a='foo &#39; bar'>bar</a>\n}, render(%q{%a(a='foo \' bar') bar}))
    assert_equal(%Q{<a a='foo \\&#39; bar'>bar</a>\n}, render(%q{%a(a='foo \\\\\' bar') bar}))

    assert_equal(%Q{<a a='foo \\ bar'>bar</a>\n}, render(%q{%a(a="foo \\\\ bar") bar}))
    assert_equal(%Q{<a a='foo \#{1 + 1} bar'>bar</a>\n}, render(%q{%a(a="foo \#{1 + 1} bar") bar}))
  end

  def test_multiline_new_attribute
    assert_equal("<a a='b' c='d'>bar</a>\n", render("%a(a='b'\n  c='d') bar"))
    assert_equal("<a a='b' b='c' c='d' d='e' e='f' f='j'>bar</a>\n",
                 render("%a(a='b' b='c'\n  c='d' d=e\n  e='f' f='j') bar", :locals => {:e => 'e'}))
  end

  def test_new_and_old_attributes
    assert_equal("<a a='b' c='d'>bar</a>\n", render("%a(a='b'){:c => 'd'} bar"))
    assert_equal("<a a='b' c='d'>bar</a>\n", render("%a{:c => 'd'}(a='b') bar"))
    assert_equal("<a a='b' c='d'>bar</a>\n", render("%a(c='d'){:a => 'b'} bar"))
    assert_equal("<a a='b' c='d'>bar</a>\n", render("%a{:a => 'b'}(c='d') bar"))

    # Old-style always takes precedence over new-style,
    # because theoretically old-style could have arbitrary end-of-method-call syntax.
    assert_equal("<a a='b'>bar</a>\n", render("%a{:a => 'b'}(a='d') bar"))
    assert_equal("<a a='b'>bar</a>\n", render("%a(a='d'){:a => 'b'} bar"))

    assert_equal("<a a='b' b='c' c='d' d='e'>bar</a>\n",
                 render("%a{:a => 'b',\n:b => 'c'}(c='d'\nd='e') bar"))

    locals = {:b => 'b', :d => 'd'}
    assert_equal("<p a='b' c='d'></p>\n", render("%p{:a => b}(c=d)", :locals => locals))
    assert_equal("<p a='b' c='d'></p>\n", render("%p(a=b){:c => d}", :locals => locals))

    assert_equal("<p id='b_d'></p>\n<p id='b_d'></p>\n", render("%p(id=b){id:d}\n%p(id=b){id:d}", locals: locals))
  end

  def test_attributes_sort_order
    # "," < "-" < "0" < "=" < "a"
    assert_equal(<<-HTML, render(<<-HAML))
<div a,='1' a-='2' a0='3' a='4' aa='5'></div>
<div a,='1' a-='2' a0='3' a='4' aa='5'></div>
    HTML
- a = 4
%div{ a: a, 'a-' => 2, aa: 5, a0: 3, 'a,' => 1 }
- hash = { a: a, 'a-' => 2, aa: 5, a0: 3, 'a,' => 1 }
%div{ hash }
    HAML

    # (no char) < "," < "-" < "0" < "a"
    assert_equal(<<-HTML, render(<<-HAML))
<div a a,='1' a-='2' a0='3' aa='4'></div>
<div a a,='1' a-='2' a0='3' aa='4'></div>
    HTML
- a = true
%div{ a: a, 'a-' => 2, aa: 4, a0: 3, 'a,' => 1 }
- hash = { a: a, 'a-' => 2, aa: 4, a0: 3, 'a,' => 1 }
%div{ hash }
    HAML

    # "," < "-" < "0" (with hyphenation)
    assert_equal(<<-HTML, render(<<-HAML))
<div a,='1' a-a='2' a0='3'></div>
<div a,='1' a-a='2' a0='3'></div>
    HTML
- a = { a: 2 }
%div{ a: a, a0: 3, 'a,' => 1 }
- hash = { a: a, a0: 3, 'a,' => 1 }
%div{ hash }
    HAML

    # "A" < "_" < "a" (with underscoration)
    assert_equal(<<-HTML, render(<<-HAML, hyphenate_data_attrs: false))
<div a-aA='1' a-a_a='2' a-aa='3'></div>
<div a-aA='1' a-a_a='2' a-aa='3'></div>
    HTML
- a = { a: { a: 2 } }
%div{ a: a, 'a-aa' => 3, 'a-aA' => 1 }
- hash = { a: a, 'a-aa' => 3, 'a-aA' => 1 }
%div{ hash }
    HAML
  end

  def test_html_attributes_with_hash
    assert_equal("<a href='#' rel='top'>Foo</a>\n",
                 render('%a(href="#" rel="top") Foo'))
    assert_equal("<a href='#'>Foo</a>\n",
                 render('%a(href="#") #{"Foo"}'))

    assert_equal("<a href='#&quot;'></a>\n", render('%a(href="#\\"")'))
  end
end