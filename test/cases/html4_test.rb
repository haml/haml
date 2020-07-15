
require 'cases/test_base'

class Html4 < TestBase

  def test_doctypes
    assert_equal('<!DOCTYPE html>',
                 render('!!!', :format => :html5).strip)
    assert_equal('<!DOCTYPE html>', render('!!! 5').strip)
    assert_equal('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
                 render('!!! strict', :format => :xhtml).strip)
    assert_equal('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">',
                 render('!!! frameset', :format => :xhtml).strip)
    assert_equal('<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">',
                 render('!!! mobile', :format => :xhtml).strip)
    assert_equal('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">',
                 render('!!! basic', :format => :xhtml).strip)
    assert_equal('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
                 render('!!! transitional', :format => :xhtml).strip)
    assert_equal('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">',
                 render('!!!', :format => :xhtml).strip)
    assert_equal('<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">',
                 render('!!! strict', :format => :html4).strip)
    assert_equal('<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">',
                 render('!!! frameset', :format => :html4).strip)
    assert_equal('<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">',
                 render('!!! transitional', :format => :html4).strip)
    assert_equal('<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">',
                 render('!!!', :format => :html4).strip)
  end

  def test_has_no_self_closing_tags
    assert_equal "<p>\n<br>\n</p>\n", render("%p\n  %br", :format => :html4)
    assert_equal "<br>\n", render("%br/", :format => :html4)
  end

  def test_renders_empty_node_with_closing_tag
    assert_equal "<div class='foo'></div>\n", render(".foo", :format => :html4)
  end

  def test_doesnt_add_slash_to_self_closing_tags
    assert_equal "<a>\n", render("%a/", :format => :html4)
    assert_equal "<a foo='2'>\n", render("%a{:foo => 1 + 1}/", :format => :html4)
    assert_equal "<meta>\n", render("%meta", :format => :html4)
    assert_equal "<meta foo='2'>\n", render("%meta{:foo => 1 + 1}", :format => :html4)
  end

  def test_ignores_xml_prolog_declaration
    assert_equal "", render('!!! XML', :format => :html4)
  end

  def test_has_different_doctype
    assert_equal %{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">\n},
                 render('!!!', :format => :html4)
  end

  # because anything before the doctype triggers quirks mode in IE
  def test_xml_prolog_and_doctype_dont_result_in_a_leading_whitespace_in_html
    refute_match(/^\s+/, render("!!! xml\n!!!", :format => :html4))
  end


  def test_xml_doc_using_html4_format_and_mime_type
    assert_equal(<<XML, render(<<HAML, { :format => :html4, :mime_type => 'text/xml' }))
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

  def test_semi_prerendered_tags
    assert_equal(<<HTML, render(<<HAML))
<p a='2'></p>
<p a='2'>foo</p>
<p a='2'>
<p a='2'>foo</p>
<p a='2'>foo
bar</p>
<p a='2'>foo
bar</p>
<p a='2'>
foo
</p>
HTML
%p{:a => 1 + 1}
%p{:a => 1 + 1} foo
%p{:a => 1 + 1}/
%p{:a => 1 + 1}= "foo"
%p{:a => 1 + 1}= "foo\\nbar"
%p{:a => 1 + 1}~ "foo\\nbar"
%p{:a => 1 + 1}
  foo
HAML
  end

  def test_xhtml_output_option
    assert_equal "<p>\n<br />\n</p>\n", render("%p\n  %br", :format => :xhtml)
    assert_equal "<a />\n", render("%a/", :format => :xhtml)
  end
end