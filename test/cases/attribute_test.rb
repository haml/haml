require 'cases/test_base'

class AttributeTest < TestBase
  def test_boolean_attributes
    assert_equal("<p bar baz='true' foo='bar'></p>\n",
                 render("%p{:foo => 'bar', :bar => true, :baz => 'true'}", :format => :html4))
    assert_equal("<p bar='bar' baz='true' foo='bar'></p>\n",
                 render("%p{:foo => 'bar', :bar => true, :baz => 'true'}", :format => :xhtml))

    assert_equal("<p baz='false' foo='bar'></p>\n",
                 render("%p{:foo => 'bar', :bar => false, :baz => 'false'}", :format => :html4))
    assert_equal("<p baz='false' foo='bar'></p>\n",
                 render("%p{:foo => 'bar', :bar => false, :baz => 'false'}", :format => :xhtml))
  end

  def test_static_attributes_with_empty_attr
    assert_equal("<img alt='' src='/foo.png'>\n", render("%img{:src => '/foo.png', :alt => ''}"))
  end

  def test_attributes_should_render_correctly
    assert_equal("<div class='atlantis' style='ugly'></div>", render(".atlantis{:style => 'ugly'}").chomp)
  end

  def test_dynamic_attributes_with_empty_attr
    assert_equal("<img alt='' src='/foo.png'>\n", render("%img{:width => nil, :src => '/foo.png', :alt => String.new}"))
  end

  def test_attribute_hash_with_newlines
    assert_equal("<p a='b' c='d'>foop</p>\n", render("%p{:a => 'b',\n   :c => 'd'} foop"))
    assert_equal("<p a='b' c='d'>\nfoop\n</p>\n", render("%p{:a => 'b',\n   :c => 'd'}\n  foop"))
    assert_equal("<p a='b' c='d'>\n", render("%p{:a => 'b',\n   :c => 'd'}/"))
    assert_equal("<p a='b' c='d' e='f'></p>\n", render("%p{:a => 'b',\n   :c => 'd',\n   :e => 'f'}"))
  end

  def test_hash_method_call_in_attributes
    assert_equal(%Q{<a foo='bar' hoge='fuga'></a>\n}, render(<<-HAML))
- hash = {:hoge => :fuga}
%a{{foo: 'bar'}.merge(hash)}
    HAML
  end

  def test_attr_wrapper
    assert_equal("<p strange=*attrs*></p>\n", render("%p{ :strange => 'attrs'}", :attr_wrapper => '*'))
    assert_equal("<p escaped=\"quo&quot;te\"></p>\n", render("%p{ :escaped => 'quo\"te'}", :attr_wrapper => '"'))
    assert_equal("<p escaped=\"quo&#39;te\"></p>\n", render("%p{ :escaped => 'quo\\'te'}", :attr_wrapper => '"'))
    assert_equal("<p escaped=\"q&#39;uo&quot;te\"></p>\n", render("%p{ :escaped => 'q\\'uo\"te'}", :attr_wrapper => '"'))
    assert_equal("<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n", render("!!! XML", :attr_wrapper => '"', :format => :xhtml))
  end

  def test_empty_attrs
    assert_equal("<p attr=''>empty</p>\n", render("%p{ :attr => '' } empty"))
    assert_equal("<p attr=''>empty</p>\n", render("%p{ :attr => x } empty", :locals => {:x => ''}))
  end

  def test_nil_attrs
    assert_equal("<p>nil</p>\n", render("%p{ :attr => nil } nil"))
    assert_equal("<p>nil</p>\n", render("%p{ :attr => x } nil", :locals => {:x => nil}))
  end

  def test_attributes_with_to_s
    assert_equal(<<HTML, render(<<HAML))
<p id='foo_2'></p>
<p class='foo 2'></p>
<p blaz='2'></p>
<p 2='2'></p>
HTML
%p#foo{:id => 1+1}
%p.foo{:class => 1+1}
%p{:blaz => 1+1}
%p{(1+1) => 1+1}
HAML
  end

  def test_nil_should_render_empty_tag
    assert_equal("<div class='no_attributes'></div>",
                 render(".no_attributes{:nil => nil}").chomp)
  end

  def test_dynamic_attributes_with_no_content
    assert_equal(<<HTML, render(<<HAML))
<p>
<a href='http://haml.info'></a>
</p>
HTML
%p
  %a{:href => "http://" + "haml.info"}
HAML
  end

  def test_dynamic_attrs_shouldnt_register_as_literal_values
    assert_equal("<p a='b2c'></p>\n", render('%p{:a => "b#{1 + 1}c"}'))
    assert_equal("<p a='b2c'></p>\n", render("%p{:a => 'b' + (1 + 1).to_s + 'c'}"))
  end

  def test_dynamic_attrs_with_self_closed_tag
    assert_equal("<a b='2'>\nc\n", render("%a{'b' => 1 + 1}/\n= 'c'\n"))
  end

  def test_non_literal_attributes
    assert_equal("<p a1='foo' a2='bar' a3='baz'></p>\n",
                 render("%p{a2, a1, :a3 => 'baz'}",
                        :locals => {:a1 => {:a1 => 'foo'}, :a2 => {:a2 => 'bar'}}))
  end

  def test_arbitrary_attribute_hash_merging
    assert_equal(%Q{<a aria-baz='qux' aria-foo='bar'></a>\n}, render(<<-HAML))
- h1 = {:aria => {:foo => :bar}}
- h2 = {:baz => :qux}
%a{h1, :aria => h2}
    HAML
  end

  def test_multiline_attributes
    assert_equal(<<HTML, render(<<HAML))
<div class='haml' data-content='/:|}' data-haml-info-url='https://haml.info' id='info'>Haml</div>
HTML
.haml#info{
  "data": {
    "content": "/:|}",
    "haml-info": {
      "url": "https://haml.info",
    }
  }
} Haml
HAML
  end
end