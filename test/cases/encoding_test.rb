require 'cases/test_base'

class EncodingTest < TestBase
  def test_utf8_attrs
    assert_equal("<a href='héllo'></a>\n", render("%a{:href => 'héllo'}"))
    assert_equal("<a href='héllo'></a>\n", render("%a(href='héllo')"))
  end

  def test_coding_comments
    assert_valid_encoding_comment("-# coding: ibm866")
    assert_valid_encoding_comment("-# CodINg: IbM866")
    assert_valid_encoding_comment("-#coding:ibm866")
    assert_valid_encoding_comment("-# CodINg= ibm866")
    assert_valid_encoding_comment("-# foo BAR FAOJcoding: ibm866")
    assert_valid_encoding_comment("-# coding: ibm866 ASFJ (&(&#!$")
    assert_valid_encoding_comment("-# -*- coding: ibm866")
    assert_valid_encoding_comment("-# coding: ibm866 -*- coding: blah")
    assert_valid_encoding_comment("-# -*- coding: ibm866 -*-")
    assert_valid_encoding_comment("-# -*- encoding: ibm866 -*-")
    assert_valid_encoding_comment('-# -*- coding: "ibm866" -*-')
    assert_valid_encoding_comment("-#-*-coding:ibm866-*-")
    assert_valid_encoding_comment("-#-*-coding:ibm866-*-")
    assert_valid_encoding_comment("-# -*- foo: bar; coding: ibm866; baz: bang -*-")
    assert_valid_encoding_comment("-# foo bar coding: baz -*- coding: ibm866 -*-")
    assert_valid_encoding_comment("-# -*- coding: ibm866 -*- foo bar coding: baz")
  end

  def test_utf_8_bom
    assert_equal <<HTML, render(<<HAML)
<div class='foo'>
<p>baz</p>
</div>
HTML
\xEF\xBB\xBF.foo
  %p baz
HAML
  end

  def test_fake_ascii_encoding
    assert_encoded_equal(<<HTML.dup.force_encoding("ascii-8bit"), render(<<HAML, :encoding => "ascii-8bit"))
<p>bâr</p>
<p>föö</p>
HTML
%p bâr
%p föö
HAML
  end

  def test_encoding_error
    render("foo\nbar\nb\xFEaz".dup.force_encoding("utf-8"))
    assert(false, "Expected exception")
  rescue Haml::Error => e
    assert_equal(3, e.line)
    assert_match(/Invalid .* character/, e.message)
  end

  def test_ascii_incompatible_encoding_error
    template = "foo\nbar\nb_z".encode("utf-16le")
    template[9] = "\xFE".dup.force_encoding("utf-16le")
    render(template)
    assert(false, "Expected exception")
  rescue Haml::Error => e
    assert_equal(3, e.line)
    assert_match(/Invalid .* character/, e.message)
  end

  def test_same_coding_comment_as_encoding
    assert_renders_encoded(<<HTML, <<HAML)
<p>bâr</p>
<p>föö</p>
HTML
-# coding: utf-8
%p bâr
%p föö
HAML
  end


  def test_different_coding_than_system
    assert_renders_encoded(<<HTML.encode("IBM866"), <<HAML.encode("IBM866"))
<p>тАЬ</p>
HTML
%p тАЬ
HAML
  end

  private

  def assert_valid_encoding_comment(comment)
    assert_renders_encoded(<<HTML.encode("IBM866"), <<HAML.encode("IBM866").force_encoding("UTF-8"))
<p>ЖЛЫ</p>
<p>тАЬ</p>
HTML
#{comment}
%p ЖЛЫ
%p тАЬ
HAML
  end

  def assert_renders_encoded(html, haml)
    result = render(haml)
    assert_encoded_equal html, result
  end

  def assert_encoded_equal(expected, actual)
    assert_equal expected.encoding, actual.encoding
    assert_equal expected, actual
  end
end
