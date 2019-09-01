$:.unshift File.expand_path('../../test', __dir__)

require 'test_helper'
require 'haml'
require 'minitest/autorun'

# This is a spec converted by haml-spec.
# See: https://github.com/haml/haml-spec
class UglyTest < MiniTest::Test
  HAML_DEFAULT_OPTIONS = { escape_html: true, escape_attrs: true }.freeze
  HAMLIT_DEFAULT_OPTIONS = { escape_html: true }.freeze

  def self.haml_result(haml, options, locals)
    Haml::Engine.new(haml, HAML_DEFAULT_OPTIONS.merge(options)).render(Object.new, locals)
  end

  def self.hamlit_result(haml, options, locals)
    Hamlit::Template.new(HAMLIT_DEFAULT_OPTIONS.merge(options)) { haml }.render(Object.new, locals)
  end

  class Headers < MiniTest::Test
    def test_an_XHTML_XML_prolog
      haml    = %q{!!! XML}
      _html   = %q{<?xml version='1.0' encoding='utf-8' ?>}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_XHTML_default_transitional_doctype
      haml    = %q{!!!}
      _html   = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_XHTML_1_1_doctype
      haml    = %q{!!! 1.1}
      _html   = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_XHTML_1_2_mobile_doctype
      haml    = %q{!!! mobile}
      _html   = %q{<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_XHTML_1_1_basic_doctype
      haml    = %q{!!! basic}
      _html   = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_XHTML_1_0_frameset_doctype
      haml    = %q{!!! frameset}
      _html   = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_5_doctype_with_XHTML_syntax
      haml    = %q{!!! 5}
      _html   = %q{<!DOCTYPE html>}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_5_XML_prolog_silent_
      haml    = %q{!!! XML}
      _html   = %q{}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_5_doctype
      haml    = %q{!!!}
      _html   = %q{<!DOCTYPE html>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_4_XML_prolog_silent_
      haml    = %q{!!! XML}
      _html   = %q{}
      locals  = {}
      options = {:format=>:html4}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_4_default_transitional_doctype
      haml    = %q{!!!}
      _html   = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">}
      locals  = {}
      options = {:format=>:html4}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_4_frameset_doctype
      haml    = %q{!!! frameset}
      _html   = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">}
      locals  = {}
      options = {:format=>:html4}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_4_strict_doctype
      haml    = %q{!!! strict}
      _html   = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">}
      locals  = {}
      options = {:format=>:html4}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Basichamltagsandcss < MiniTest::Test
    def test_a_simple_Haml_tag
      haml    = %q{%p}
      _html   = %q{<p></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_self_closing_tag_XHTML_
      haml    = %q{%meta}
      _html   = %q{<meta />}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_self_closing_tag_HTML4_
      haml    = %q{%meta}
      _html   = %q{<meta>}
      locals  = {}
      options = {:format=>:html4}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_self_closing_tag_HTML5_
      haml    = %q{%meta}
      _html   = %q{<meta>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_self_closing_tag_modifier_XHTML_
      haml    = %q{%zzz/}
      _html   = %q{<zzz />}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_self_closing_tag_modifier_HTML5_
      haml    = %q{%zzz/}
      _html   = %q{<zzz>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_a_CSS_class
      haml    = %q{%p.class1}
      _html   = %q{<p class='class1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_multiple_CSS_classes
      haml    = %q{%p.class1.class2}
      _html   = %q{<p class='class1 class2'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_a_CSS_id
      haml    = %q{%p#id1}
      _html   = %q{<p id='id1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_multiple_CSS_id_s
      haml    = %q{%p#id1#id2}
      _html   = %q{<p id='id2'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_a_class_followed_by_an_id
      haml    = %q{%p.class1#id1}
      _html   = %q{<p class='class1' id='id1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_an_id_followed_by_a_class
      haml    = %q{%p#id1.class1}
      _html   = %q{<p class='class1' id='id1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_implicit_div_with_a_CSS_id
      haml    = %q{#id1}
      _html   = %q{<div id='id1'></div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_implicit_div_with_a_CSS_class
      haml    = %q{.class1}
      _html   = %q{<div class='class1'></div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_multiple_simple_Haml_tags
      haml    = %q{%div
  %div
    %p}
      _html   = %q{<div>
  <div>
    <p></p>
  </div>
</div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Tagswithunusualhtmlcharacters < MiniTest::Test
    def test_a_tag_with_colons
      haml    = %q{%ns:tag}
      _html   = %q{<ns:tag></ns:tag>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_underscores
      haml    = %q{%snake_case}
      _html   = %q{<snake_case></snake_case>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_dashes
      haml    = %q{%dashed-tag}
      _html   = %q{<dashed-tag></dashed-tag>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_camelCase
      haml    = %q{%camelCase}
      _html   = %q{<camelCase></camelCase>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_PascalCase
      haml    = %q{%PascalCase}
      _html   = %q{<PascalCase></PascalCase>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Tagswithunusualcssidentifiers < MiniTest::Test
    def test_an_all_numeric_class
      haml    = %q{.123}
      _html   = %q{<div class='123'></div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_class_with_underscores
      haml    = %q{.__}
      _html   = %q{<div class='__'></div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_class_with_dashes
      haml    = %q{.--}
      _html   = %q{<div class='--'></div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Tagswithinlinecontent < MiniTest::Test
    def test_Inline_content_simple_tag
      haml    = %q{%p hello}
      _html   = %q{<p>hello</p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Inline_content_tag_with_CSS
      haml    = %q{%p.class1 hello}
      _html   = %q{<p class='class1'>hello</p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Inline_content_multiple_simple_tags
      haml    = %q{%div
  %div
    %p text}
      _html   = %q{<div>
  <div>
    <p>text</p>
  </div>
</div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Tagswithnestedcontent < MiniTest::Test
    def test_Nested_content_simple_tag
      haml    = %q{%p
  hello}
      _html   = %q{<p>
  hello
</p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Nested_content_tag_with_CSS
      haml    = %q{%p.class1
  hello}
      _html   = %q{<p class='class1'>
  hello
</p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Nested_content_multiple_simple_tags
      haml    = %q{%div
  %div
    %p
      text}
      _html   = %q{<div>
  <div>
    <p>
      text
    </p>
  </div>
</div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Tagswithhtmlstyleattributes < MiniTest::Test
    def test_HTML_style_one_attribute
      haml    = %q{%p(a='b')}
      _html   = %q{<p a='b'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_multiple_attributes
      haml    = %q{%p(a='b' c='d')}
      _html   = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_attributes_separated_with_newlines
      haml    = %q{%p(a='b'
  c='d')}
      _html   = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_interpolated_attribute
      haml    = %q{%p(a="#{var}")}
      _html   = %q{<p a='value'></p>}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_class_as_an_attribute
      haml    = %q{%p(class='class1')}
      _html   = %q{<p class='class1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_with_a_CSS_class_and_class_as_an_attribute
      haml    = %q{%p.class2(class='class1')}
      _html   = %q{<p class='class1 class2'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_with_id_as_an_attribute
      haml    = %q{%p(id='1')}
      _html   = %q{<p id='1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_with_a_CSS_id_and_id_as_an_attribute
      haml    = %q{%p#id(id='1')}
      _html   = %q{<p id='id_1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_with_a_variable_attribute
      haml    = %q{%p(class=var)}
      _html   = %q{<p class='hello'></p>}
      locals  = {:var=>"hello"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_with_a_CSS_class_and_class_as_a_variable_attribute
      haml    = %q{.hello(class=var)}
      _html   = %q{<div class='hello world'></div>}
      locals  = {:var=>"world"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_multiple_CSS_classes_sorted_correctly_
      haml    = %q{.z(class=var)}
      _html   = %q{<div class='a z'></div>}
      locals  = {:var=>"a"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_with_an_atomic_attribute
      skip '[INCOMPATIBILITY] Hamlit limits boolean attributes'
      haml    = %q{%a(flag)}
      _html   = %q{<a flag></a>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Tagswithrubystyleattributes < MiniTest::Test
    def test_Ruby_style_one_attribute
      haml    = %q{%p{:a => 'b'}}
      _html   = %q{<p a='b'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_attributes_hash_with_whitespace
      haml    = %q{%p{  :a  =>  'b'  }}
      _html   = %q{<p a='b'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_interpolated_attribute
      haml    = %q{%p{:a =>"#{var}"}}
      _html   = %q{<p a='value'></p>}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_multiple_attributes
      haml    = %q{%p{ :a => 'b', 'c' => 'd' }}
      _html   = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_attributes_separated_with_newlines
      haml    = %q{%p{ :a => 'b',
  'c' => 'd' }}
      _html   = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_class_as_an_attribute
      haml    = %q{%p{:class => 'class1'}}
      _html   = %q{<p class='class1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_with_a_CSS_class_and_class_as_an_attribute
      haml    = %q{%p.class2{:class => 'class1'}}
      _html   = %q{<p class='class1 class2'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_with_id_as_an_attribute
      haml    = %q{%p{:id => '1'}}
      _html   = %q{<p id='1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_with_a_CSS_id_and_id_as_an_attribute
      haml    = %q{%p#id{:id => '1'}}
      _html   = %q{<p id='id_1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_with_a_CSS_id_and_a_numeric_id_as_an_attribute
      haml    = %q{%p#id{:id => 1}}
      _html   = %q{<p id='id_1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_with_a_variable_attribute
      haml    = %q{%p{:class => var}}
      _html   = %q{<p class='hello'></p>}
      locals  = {:var=>"hello"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_with_a_CSS_class_and_class_as_a_variable_attribute
      haml    = %q{.hello{:class => var}}
      _html   = %q{<div class='hello world'></div>}
      locals  = {:var=>"world"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_multiple_CSS_classes_sorted_correctly_
      haml    = %q{.z{:class => var}}
      _html   = %q{<div class='a z'></div>}
      locals  = {:var=>"a"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Silentcomments < MiniTest::Test
    def test_an_inline_silent_comment
      haml    = %q{-# hello}
      _html   = %q{}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_nested_silent_comment
      haml    = %q{-#
  hello}
      _html   = %q{}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_multiply_nested_silent_comment
      haml    = %q{-#
  %div
    foo}
      _html   = %q{}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_multiply_nested_silent_comment_with_inconsistent_indents
      haml    = %q{-#
  %div
      foo}
      _html   = %q{}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Markupcomments < MiniTest::Test
    def test_an_inline_markup_comment
      haml    = %q{/ comment}
      _html   = %q{<!-- comment -->}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_nested_markup_comment
      haml    = %q{/
  comment
  comment2}
      _html   = %q{<!--
  comment
  comment2
-->}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Conditionalcomments < MiniTest::Test
    def test_a_conditional_comment
      haml    = %q{/[if IE]
  %p a}
      _html   = %q{<!--[if IE]>
  <p>a</p>
<![endif]-->}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Internalfilters < MiniTest::Test
    def test_content_in_an_escaped_filter
      haml    = %q{:escaped
  <&">}
      _html   = %q{&lt;&amp;&quot;&gt;}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_content_in_a_preserve_filter
      haml    = %q{:preserve
  hello

%p}
      _html   = %q{hello&#x000A;
<p></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_content_in_a_plain_filter
      haml    = %q{:plain
  hello

%p}
      _html   = %q{hello
<p></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_content_in_a_css_filter_XHTML_
      haml    = %q{:css
  hello

%p}
      _html   = %q{<style type='text/css'>
  /*<![CDATA[*/
    hello
  /*]]>*/
</style>
<p></p>}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_content_in_a_javascript_filter_XHTML_
      haml    = %q{:javascript
  a();
%p}
      _html   = %q{<script type='text/javascript'>
  //<![CDATA[
    a();
  //]]>
</script>
<p></p>}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_content_in_a_css_filter_HTML_
      haml    = %q{:css
  hello

%p}
      _html   = %q{<style>
  hello
</style>
<p></p>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_content_in_a_javascript_filter_HTML_
      haml    = %q{:javascript
  a();
%p}
      _html   = %q{<script>
  a();
</script>
<p></p>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Rubystyleinterpolation < MiniTest::Test
    def test_interpolation_inside_inline_content
      haml    = %q{%p #{var}}
      _html   = %q{<p>value</p>}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_no_interpolation_when_escaped
      haml    = %q{%p \#{var}}
      _html   = %q{<p>#{var}</p>}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_interpolation_when_the_escape_character_is_escaped
      haml    = %q{%p \\#{var}}
      _html   = %q{<p>\value</p>}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_interpolation_inside_filtered_content
      haml    = %q{:plain
  #{var} interpolated: #{var}}
      _html   = %q{value interpolated: value}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Htmlescaping < MiniTest::Test
    def test_code_following_
      haml    = %q{&= '<"&>'}
      _html   = %q{&lt;&quot;&amp;&gt;}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_code_following_eq_when_escape_haml_is_set_to_true
      haml    = %q{= '<"&>'}
      _html   = %q{&lt;&quot;&amp;&gt;}
      locals  = {}
      options = {:escape_html=>"true"}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_code_following_neq_when_escape_haml_is_set_to_true
      haml    = %q{!= '<"&>'}
      _html   = %q{<"&>}
      locals  = {}
      options = {:escape_html=>"true"}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Booleanattributes < MiniTest::Test
    def test_boolean_attribute_with_XHTML
      haml    = %q{%input(checked=true)}
      _html   = %q{<input checked='checked' />}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_boolean_attribute_with_HTML
      haml    = %q{%input(checked=true)}
      _html   = %q{<input checked>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Whitespacepreservation < MiniTest::Test
    def test_following_the_operator
      haml    = %q{~ "Foo\n<pre>Bar\nBaz</pre>"}
      _html   = %q{Foo
<pre>Bar&#x000A;Baz</pre>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_inside_a_textarea_tag
      haml    = %q{%textarea
  hello
  hello}
      _html   = %q{<textarea>hello
hello</textarea>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_inside_a_pre_tag
      haml    = %q{%pre
  hello
  hello}
      _html   = %q{<pre>hello
hello</pre>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Whitespaceremoval < MiniTest::Test
    def test_a_tag_with_appended_and_inline_content
      haml    = %q{%li hello
%li> world
%li again}
      _html   = %q{<li>hello</li><li>world</li><li>again</li>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_appended_and_nested_content
      haml    = %q{%li hello
%li>
  world
%li again}
      _html   = %q{<li>hello</li><li>
  world
</li><li>again</li>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_appended
      haml    = %q{%p<
  hello
  world}
      _html   = %q{<p>hello
world</p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end
end
