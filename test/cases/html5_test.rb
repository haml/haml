require 'cases/test_base'

class Html5Test < TestBase


  # HTML5
  def test_html5_doctype
    assert_equal %{<!DOCTYPE html>\n}, render('!!!', :format => :html5)
  end

  # HTML5 custom data attributes
  def test_html5_data_attributes_without_hyphenation
    assert_equal("<div data-author_id='123' data-biz='baz' data-foo='bar'></div>\n",
                 render("%div{:data => {:author_id => 123, :foo => 'bar', :biz => 'baz'}}",
                        :hyphenate_data_attrs => false))

    assert_equal("<div data-one_plus_one='2'></div>\n",
                 render("%div{:data => {:one_plus_one => 1+1}}",
                        :hyphenate_data_attrs => false))

    assert_equal("<div data-foo='Here&#39;s a &quot;quoteful&quot; string.'></div>\n",
                 render(%{%div{:data => {:foo => %{Here's a "quoteful" string.}}}},
                        :hyphenate_data_attrs => false)) #'
  end

  def test_html5_data_attributes_with_hyphens
    assert_equal("<div data-foo-bar='blip'></div>\n",
                 render("%div{:data => {:foo_bar => 'blip'}}"))
    assert_equal("<div data-baz='bang' data-foo-bar='blip'></div>\n",
                 render("%div{:data => {:foo_bar => 'blip', :baz => 'bang'}}"))
  end

  def test_html5_arbitrary_hash_valued_attributes_with
    assert_equal("<div aria-foo='blip'></div>\n",
                 render("%div{:aria => {:foo => 'blip'}}"))
    assert_equal("<div foo-baz='bang'></div>\n",
                 render("%div{:foo => {:baz => 'bang'}}"))
  end


  def test_html5_data_attributes_with_nested_hash
    assert_equal("<div data-a-b='c'></div>\n", render(<<-HAML))
- hash = {:a => {:b => 'c'}}
- hash[:d] = hash
%div{:data => hash}
    HAML
  end

  def test_html5_data_attributes_with_nested_hash_and_without_hyphenation
    assert_equal("<div data-a_b='c'></div>\n", render(<<-HAML, :hyphenate_data_attrs => false))
- hash = {:a => {:b => 'c'}}
- hash[:d] = hash
%div{:data => hash}
    HAML
  end

  def test_html5_data_attributes_with_multiple_defs
    # Should always use the more-explicit attribute
    assert_equal("<div data-foo='second'></div>\n",
                 render("%div{:data => {:foo => 'first'}, 'data-foo' => 'second'}"))
    assert_equal("<div data-foo='first'></div>\n",
                 render("%div{'data-foo' => 'first', :data => {:foo => 'second'}}"))
  end

  def test_html5_data_attributes_with_attr_method
    obj = Object.new

    def obj.data_hash
      {:data => {:foo => "bar", :baz => "bang"}}
    end

    def obj.data_val
      {:data => "dat"}
    end

    assert_equal("<div data-baz='bang' data-brat='wurst' data-foo='blip'></div>\n",
                 render("%div{data_hash, :data => {:foo => 'blip', :brat => 'wurst'}}", scope: obj))
    assert_equal("<div data-baz='bang' data-foo='blip'></div>\n",
                 render("%div{data_hash, 'data-foo' => 'blip'}", scope: obj))
    assert_equal("<div data-baz='bang' data-foo='bar' data='dat'></div>\n",
                 render("%div{data_hash, :data => 'dat'}", scope: obj))
    assert_equal("<div data-brat='wurst' data-foo='blip' data='dat'></div>\n",
                 render("%div{data_val, :data => {:foo => 'blip', :brat => 'wurst'}}", scope: obj))
  end

  def test_html5_data_attributes_with_identical_attribute_values
    assert_equal("<div data-x='50' data-y='50'></div>\n",
                 render("%div{:data => {:x => 50, :y => 50}}"))
  end

  def test_xml_doc_using_html5_format_and_mime_type
    assert_equal(<<XML, render(<<HAML, {:format => :html5, :mime_type => 'text/xml'}))
<?xml version='1.0' encoding='utf-8' ?>
<root>
<element />
<hr />
</root>
XML
!!! XML
%root
  %element/
  %hr
HAML
  end
end