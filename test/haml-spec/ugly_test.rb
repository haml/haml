require "minitest/autorun"
require "hamlit"

# This is a spec converted by haml-spec.
# See: https://github.com/haml/haml-spec
class UglyTest < MiniTest::Test
  DEFAULT_OPTIONS = { ugly: true }.freeze

  def self.haml_result(haml, options, locals)
    Haml::Engine.new(haml, DEFAULT_OPTIONS.merge(options)).render(Object.new, locals)
  end

  def self.hamlit_result(haml, options, locals)
    Hamlit::HamlEngine.new(haml, DEFAULT_OPTIONS.merge(options)).render(Object.new, locals)
  end

  class Headers < MiniTest::Test
    def test_an_XHTML_XML_prolog
      haml    = %q{!!! XML}
      html    = %q{<?xml version='1.0' encoding='utf-8' ?>}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_XHTML_default_transitional_doctype
      haml    = %q{!!!}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_XHTML_1_1_doctype
      haml    = %q{!!! 1.1}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_XHTML_1_2_mobile_doctype
      haml    = %q{!!! mobile}
      html    = %q{<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_XHTML_1_1_basic_doctype
      haml    = %q{!!! basic}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_XHTML_1_0_frameset_doctype
      haml    = %q{!!! frameset}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_5_doctype_with_XHTML_syntax
      haml    = %q{!!! 5}
      html    = %q{<!DOCTYPE html>}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_5_XML_prolog_silent_
      haml    = %q{!!! XML}
      html    = %q{}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_5_doctype
      haml    = %q{!!!}
      html    = %q{<!DOCTYPE html>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_4_XML_prolog_silent_
      haml    = %q{!!! XML}
      html    = %q{}
      locals  = {}
      options = {:format=>:html4}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_4_default_transitional_doctype
      haml    = %q{!!!}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">}
      locals  = {}
      options = {:format=>:html4}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_4_frameset_doctype
      haml    = %q{!!! frameset}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">}
      locals  = {}
      options = {:format=>:html4}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_HTML_4_strict_doctype
      haml    = %q{!!! strict}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">}
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
      html    = %q{<p></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_self_closing_tag_XHTML_
      haml    = %q{%meta}
      html    = %q{<meta />}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_self_closing_tag_HTML4_
      haml    = %q{%meta}
      html    = %q{<meta>}
      locals  = {}
      options = {:format=>:html4}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_self_closing_tag_HTML5_
      haml    = %q{%meta}
      html    = %q{<meta>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_self_closing_tag_modifier_XHTML_
      haml    = %q{%zzz/}
      html    = %q{<zzz />}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_self_closing_tag_modifier_HTML5_
      haml    = %q{%zzz/}
      html    = %q{<zzz>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_a_CSS_class
      haml    = %q{%p.class1}
      html    = %q{<p class='class1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_multiple_CSS_classes
      haml    = %q{%p.class1.class2}
      html    = %q{<p class='class1 class2'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_a_CSS_id
      haml    = %q{%p#id1}
      html    = %q{<p id='id1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_multiple_CSS_id_s
      haml    = %q{%p#id1#id2}
      html    = %q{<p id='id2'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_a_class_followed_by_an_id
      haml    = %q{%p.class1#id1}
      html    = %q{<p class='class1' id='id1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_a_tag_with_an_id_followed_by_a_class
      haml    = %q{%p#id1.class1}
      html    = %q{<p class='class1' id='id1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_implicit_div_with_a_CSS_id
      haml    = %q{#id1}
      html    = %q{<div id='id1'></div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_an_implicit_div_with_a_CSS_class
      haml    = %q{.class1}
      html    = %q{<div class='class1'></div>}
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
      html    = %q{<div>
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
      html    = %q{<ns:tag></ns:tag>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_underscores
      haml    = %q{%snake_case}
      html    = %q{<snake_case></snake_case>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_dashes
      haml    = %q{%dashed-tag}
      html    = %q{<dashed-tag></dashed-tag>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_camelCase
      haml    = %q{%camelCase}
      html    = %q{<camelCase></camelCase>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_tag_with_PascalCase
      haml    = %q{%PascalCase}
      html    = %q{<PascalCase></PascalCase>}
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
      html    = %q{<div class='123'></div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_class_with_underscores
      haml    = %q{.__}
      html    = %q{<div class='__'></div>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_class_with_dashes
      haml    = %q{.--}
      html    = %q{<div class='--'></div>}
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
      html    = %q{<p>hello</p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Inline_content_tag_with_CSS
      haml    = %q{%p.class1 hello}
      html    = %q{<p class='class1'>hello</p>}
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
      html    = %q{<div>
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
      html    = %q{<p>
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
      html    = %q{<p class='class1'>
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
      html    = %q{<div>
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
      html    = %q{<p a='b'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_multiple_attributes
      haml    = %q{%p(a='b' c='d')}
      html    = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_attributes_separated_with_newlines
      haml    = %q{%p(a='b'
  c='d')}
      html    = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_interpolated_attribute
      haml    = %q{%p(a="#{var}")}
      html    = %q{<p a='value'></p>}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_class_as_an_attribute
      haml    = %q{%p(class='class1')}
      html    = %q{<p class='class1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_with_a_CSS_class_and_class_as_an_attribute
      haml    = %q{%p.class2(class='class1')}
      html    = %q{<p class='class1 class2'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_with_id_as_an_attribute
      haml    = %q{%p(id='1')}
      html    = %q{<p id='1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_with_a_CSS_id_and_id_as_an_attribute
      haml    = %q{%p#id(id='1')}
      html    = %q{<p id='id_1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_HTML_style_tag_with_a_variable_attribute
      haml    = %q{%p(class=var)}
      html    = %q{<p class='hello'></p>}
      locals  = {:var=>"hello"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_HTML_style_tag_with_a_CSS_class_and_class_as_a_variable_attribute
      haml    = %q{.hello(class=var)}
      html    = %q{<div class='hello world'></div>}
      locals  = {:var=>"world"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_HTML_style_tag_multiple_CSS_classes_sorted_correctly_
      haml    = %q{.z(class=var)}
      html    = %q{<div class='a z'></div>}
      locals  = {:var=>"a"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_HTML_style_tag_with_an_atomic_attribute
      haml    = %q{%a(flag)}
      html    = %q{<a flag></a>}
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
      html    = %q{<p a='b'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_attributes_hash_with_whitespace
      haml    = %q{%p{  :a  =>  'b'  }}
      html    = %q{<p a='b'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_interpolated_attribute
      haml    = %q{%p{:a =>"#{var}"}}
      html    = %q{<p a='value'></p>}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_multiple_attributes
      haml    = %q{%p{ :a => 'b', 'c' => 'd' }}
      html    = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_attributes_separated_with_newlines
      haml    = %q{%p{ :a => 'b',
  'c' => 'd' }}
      html    = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_class_as_an_attribute
      haml    = %q{%p{:class => 'class1'}}
      html    = %q{<p class='class1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_with_a_CSS_class_and_class_as_an_attribute
      haml    = %q{%p.class2{:class => 'class1'}}
      html    = %q{<p class='class1 class2'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_with_id_as_an_attribute
      haml    = %q{%p{:id => '1'}}
      html    = %q{<p id='1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_with_a_CSS_id_and_id_as_an_attribute
      haml    = %q{%p#id{:id => '1'}}
      html    = %q{<p id='id_1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_Ruby_style_tag_with_a_CSS_id_and_a_numeric_id_as_an_attribute
      haml    = %q{%p#id{:id => 1}}
      html    = %q{<p id='id_1'></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_Ruby_style_tag_with_a_variable_attribute
      haml    = %q{%p{:class => var}}
      html    = %q{<p class='hello'></p>}
      locals  = {:var=>"hello"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_Ruby_style_tag_with_a_CSS_class_and_class_as_a_variable_attribute
      haml    = %q{.hello{:class => var}}
      html    = %q{<div class='hello world'></div>}
      locals  = {:var=>"world"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_Ruby_style_tag_multiple_CSS_classes_sorted_correctly_
      haml    = %q{.z{:class => var}}
      html    = %q{<div class='a z'></div>}
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
      html    = %q{}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_a_nested_silent_comment
      haml    = %q{-#
  hello}
      html    = %q{}
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
      html    = %q{}
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
      html    = %q{}
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
      html    = %q{<!-- comment -->}
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
      html    = %q{<!--
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
    def _test_a_conditional_comment
      haml    = %q{/[if IE]
  %p a}
      html    = %q{<!--[if IE]>
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
      html    = %q{&lt;&amp;&quot;&gt;}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_content_in_a_preserve_filter
      haml    = %q{:preserve
  hello

%p}
      html    = %q{hello&#x000A;
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
      html    = %q{hello
<p></p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_content_in_a_css_filter_XHTML_
      haml    = %q{:css
  hello

%p}
      html    = %q{<style type='text/css'>
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

    def _test_content_in_a_javascript_filter_XHTML_
      haml    = %q{:javascript
  a();
%p}
      html    = %q{<script type='text/javascript'>
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

    def _test_content_in_a_css_filter_HTML_
      haml    = %q{:css
  hello

%p}
      html    = %q{<style>
  hello
</style>
<p></p>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_content_in_a_javascript_filter_HTML_
      haml    = %q{:javascript
  a();
%p}
      html    = %q{<script>
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
      html    = %q{<p>value</p>}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_no_interpolation_when_escaped
      haml    = %q{%p \#{var}}
      html    = %q{<p>#{var}</p>}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_interpolation_when_the_escape_character_is_escaped
      haml    = %q{%p \\#{var}}
      html    = %q{<p>\value</p>}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_interpolation_inside_filtered_content
      haml    = %q{:plain
  #{var} interpolated: #{var}}
      html    = %q{value interpolated: value}
      locals  = {:var=>"value"}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Htmlescaping < MiniTest::Test
    def _test_code_following_
      haml    = %q{&= '<"&>'}
      html    = %q{&lt;&quot;&amp;&gt;}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_code_following_when_escape_haml_is_set_to_true
      haml    = %q{= '<"&>'}
      html    = %q{&lt;&quot;&amp;&gt;}
      locals  = {}
      options = {:escape_html=>"true"}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def _test_code_following_!_when_escape_haml_is_set_to_true
      haml    = %q{!= '<"&>'}
      html    = %q{<"&>}
      locals  = {}
      options = {:escape_html=>"true"}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Booleanattributes < MiniTest::Test
    def _test_boolean_attribute_with_XHTML
      haml    = %q{%input(checked=true)}
      html    = %q{<input checked='checked' />}
      locals  = {}
      options = {:format=>:xhtml}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end

    def test_boolean_attribute_with_HTML
      haml    = %q{%input(checked=true)}
      html    = %q{<input checked>}
      locals  = {}
      options = {:format=>:html5}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end

  class Whitespacepreservation < MiniTest::Test
    def _test_following_the_operator
      haml    = %q{~ "Foo\n<pre>Bar\nBaz</pre>"}
      html    = %q{Foo
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
      html    = %q{<textarea>hello
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
      html    = %q{<pre>hello
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
      html    = %q{<li>hello</li><li>world</li><li>again</li>}
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
      html    = %q{<li>hello</li><li>
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
      html    = %q{<p>hello
world</p>}
      locals  = {}
      options = {}
      haml_result = UglyTest.haml_result(haml, options, locals)
      hamlit_result = UglyTest.hamlit_result(haml, options, locals)
      assert_equal haml_result, hamlit_result
    end
  end
end
