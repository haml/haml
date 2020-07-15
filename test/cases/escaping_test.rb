require 'cases/test_base'

class EscapingTest < TestBase

  def test_escape_attrs_false
    assert_equal(<<HTML, render(<<HAML, :escape_attrs => false))
<div class='<?php echo "&quot;" ?>' id='foo'>
bar
</div>
HTML
#foo{:class => '<?php echo "&quot;" ?>'}
  bar
HAML
  end

  def test_escape_attrs_always
    assert_equal(<<HTML, render(<<HAML, :escape_attrs => true))
<div class='&quot;&amp;lt;&amp;gt;&amp;amp;&quot;' id='foo'>
bar
</div>
HTML
#foo{:class => '"&lt;&gt;&amp;"'}
  bar
HAML
  end

  def test_escape_html
    html = <<HTML
&amp;
&
&amp;
HTML

    assert_equal(html, render(<<HAML, :escape_html => true))
&= "&"
!= "&"
= "&"
HAML

    assert_equal(html, render(<<HAML, :escape_html => true))
&~ "&"
!~ "&"
~ "&"
HAML

    assert_equal(html, render(<<HAML, :escape_html => true))
& \#{"&"}
! \#{"&"}
\#{"&"}
HAML

    assert_equal(html, render(<<HAML, :escape_html => true))
&== \#{"&"}
!== \#{"&"}
== \#{"&"}
HAML

    tag_html = <<HTML
<p>&amp;</p>
<p>&</p>
<p>&amp;</p>
HTML

    assert_equal(tag_html, render(<<HAML, :escape_html => true))
%p&= "&"
%p!= "&"
%p= "&"
HAML

    assert_equal(tag_html, render(<<HAML, :escape_html => true))
%p&~ "&"
%p!~ "&"
%p~ "&"
HAML

    assert_equal(tag_html, render(<<HAML, :escape_html => true))
%p& \#{"&"}
%p! \#{"&"}
%p \#{"&"}
HAML

    assert_equal(tag_html, render(<<HAML, :escape_html => true))
%p&== \#{"&"}
%p!== \#{"&"}
%p== \#{"&"}
HAML
  end

  def test_ampersand_equals_should_escape
    assert_equal("<p>\nfoo &amp; bar\n</p>\n", render("%p\n  &= 'foo & bar'", :escape_html => false))
  end

  def test_ampersand_equals_inline_should_escape
    assert_equal("<p>foo &amp; bar</p>\n", render("%p&= 'foo & bar'", :escape_html => false))
  end

  def test_ampersand_equals_should_escape_before_preserve
    assert_equal("<textarea>foo&#x000A;bar</textarea>\n", render('%textarea&= "foo\nbar"', :escape_html => false))
  end

  def test_bang_equals_should_not_escape
    assert_equal("<p>\nfoo & bar\n</p>\n", render("%p\n  != 'foo & bar'", :escape_html => true))
  end

  def test_bang_equals_inline_should_not_escape
    assert_equal("<p>foo & bar</p>\n", render("%p!= 'foo & bar'", :escape_html => true))
  end

  def test_static_attributes_should_be_escaped
    assert_equal("<img class='atlantis' style='ugly&amp;stupid'>\n",
                 render("%img.atlantis{:style => 'ugly&stupid'}"))
    assert_equal("<div class='atlantis' style='ugly&amp;stupid'>foo</div>\n",
                 render(".atlantis{:style => 'ugly&stupid'} foo"))
    assert_equal("<p class='atlantis' style='ugly&amp;stupid'>foo</p>\n",
                 render("%p.atlantis{:style => 'ugly&stupid'}= 'foo'"))
  end

  def test_dynamic_attributes_should_be_escaped
    assert_equal("<img alt='' src='&amp;foo.png'>\n",
                 render("%img{:width => nil, :src => '&foo.png', :alt => String.new}"))
    assert_equal("<p alt='' src='&amp;foo.png'>foo</p>\n",
                 render("%p{:width => nil, :src => '&foo.png', :alt => String.new} foo"))
    assert_equal("<div alt='' src='&amp;foo.png'>foo</div>\n",
                 render("%div{:width => nil, :src => '&foo.png', :alt => String.new}= 'foo'"))
  end

  def test_string_double_equals_should_be_esaped
    assert_equal("<p>4&&lt;</p>\n", render("%p== \#{2+2}&\#{'<'}", :escape_html => true))
    assert_equal("<p>4&<</p>\n", render("%p== \#{2+2}&\#{'<'}", :escape_html => false))
  end

  def test_escaped_inline_string_double_equals
    assert_equal("<p>4&&lt;</p>\n", render("%p&== \#{2+2}&\#{'<'}", :escape_html => true))
    assert_equal("<p>4&&lt;</p>\n", render("%p&== \#{2+2}&\#{'<'}", :escape_html => false))
  end

  def test_unescaped_inline_string_double_equals
    assert_equal("<p>4&<</p>\n", render("%p!== \#{2+2}&\#{'<'}", :escape_html => true))
    assert_equal("<p>4&<</p>\n", render("%p!== \#{2+2}&\#{'<'}", :escape_html => false))
  end

  def test_escaped_string_double_equals
    assert_equal("<p>\n4&&lt;\n</p>\n", render("%p\n  &== \#{2+2}&\#{'<'}", :escape_html => true))
    assert_equal("<p>\n4&&lt;\n</p>\n", render("%p\n  &== \#{2+2}&\#{'<'}", :escape_html => false))
  end

  def test_unescaped_string_double_equals
    assert_equal("<p>\n4&<\n</p>\n", render("%p\n  !== \#{2+2}&\#{'<'}", :escape_html => true))
    assert_equal("<p>\n4&<\n</p>\n", render("%p\n  !== \#{2+2}&\#{'<'}", :escape_html => false))
  end

  def test_string_interpolation_should_be_esaped
    assert_equal("<p>4&&lt;</p>\n", render("%p \#{2+2}&\#{'<'}", :escape_html => true))
    assert_equal("<p>4&<</p>\n", render("%p \#{2+2}&\#{'<'}", :escape_html => false))
  end

  def test_escaped_inline_string_interpolation
    assert_equal("<p>4&&lt;</p>\n", render("%p& \#{2+2}&\#{'<'}", :escape_html => true))
    assert_equal("<p>4&&lt;</p>\n", render("%p& \#{2+2}&\#{'<'}", :escape_html => false))
  end

  def test_unescaped_inline_string_interpolation
    assert_equal("<p>4&<</p>\n", render("%p! \#{2+2}&\#{'<'}", :escape_html => true))
    assert_equal("<p>4&<</p>\n", render("%p! \#{2+2}&\#{'<'}", :escape_html => false))
  end

  def test_escaped_string_interpolation
    assert_equal("<p>\n4&&lt;\n</p>\n", render("%p\n  & \#{2+2}&\#{'<'}", :escape_html => true))
    assert_equal("<p>\n4&&lt;\n</p>\n", render("%p\n  & \#{2+2}&\#{'<'}", :escape_html => false))
  end

  def test_escaped_string_interpolation_with_no_space
    assert_equal("&lt;br&gt;\n", render('&#{"<br>"}'))
    assert_equal("<span>&lt;br&gt;</span>\n", render('%span&#{"<br>"}'))
  end

  def test_unescaped_string_interpolation
    assert_equal("<p>\n4&<\n</p>\n", render("%p\n  ! \#{2+2}&\#{'<'}", :escape_html => true))
    assert_equal("<p>\n4&<\n</p>\n", render("%p\n  ! \#{2+2}&\#{'<'}", :escape_html => false))
  end

  def test_unescaped_string_interpolation_with_no_space
    assert_equal("<br>\n", render('!#{"<br>"}'))
    assert_equal("<span><br></span>\n", render('%span!#{"<br>"}'))
  end

  def test_scripts_should_respect_escape_html_option
    assert_equal("<p>\nfoo &amp; bar\n</p>\n", render("%p\n  = 'foo & bar'", :escape_html => true))
    assert_equal("<p>\nfoo & bar\n</p>\n", render("%p\n  = 'foo & bar'", :escape_html => false))
  end

  def test_inline_scripts_should_respect_escape_html_option
    assert_equal("<p>foo &amp; bar</p>\n", render("%p= 'foo & bar'", :escape_html => true))
    assert_equal("<p>foo & bar</p>\n", render("%p= 'foo & bar'", :escape_html => false))
  end

  def test_script_ending_in_comment_should_render_when_html_is_escaped
    assert_equal("foo&amp;bar\n", render("= 'foo&bar' #comment", :escape_html => true))
  end

  def test_escape_html_with_interpolated_if_statement
    assert_equal(<<HTML, render(<<HAML, :escape_html => true))
foo,
HTML
foo\#{"," if true}
HAML
  end

  def test_mime_type_text_plain_with_interpolation
    assert_equal("&\n", render("\#{'&'}", :escape_html => true, :mime_type => 'text/plain'))
  end
end