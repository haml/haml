require 'cases/test_base'

class WhitespaceTest < TestBase
  def test_empty_render_should_remain_empty
    assert_equal('', render(''))
  end

  def test_spacing_inside_tag
    assert_equal("<div id='outer'>\n<div id='inner'>\n<p>hello world</p>\n</div>\n</div>\n",
                 render("#outer\n  #inner\n    %p hello world"))

    assert_equal("<p>#{'s' * 75}</p>\n",
                 render("%p #{'s' * 75}"))

    assert_equal("<p>#{'s' * 75}</p>\n",
                 render("%p= 's' * 75"))
  end

  def test_auto_preserve
    assert_equal("<pre>foo&#x000A;bar</pre>\n", render('%pre="foo\nbar"'))
    assert_equal("<pre>foo\nbar</pre>\n", render("%pre\n  foo\n  bar"))
  end

  def test_strings_should_get_stripped_inside_tags
    assert_equal("<div class='stripped'>This should have no spaces in front of it</div>",
                 render(".stripped    This should have no spaces in front of it").chomp)
  end

  def test_one_liner_should_be_one_line
    assert_equal("<p>Hello</p>", render('%p Hello').chomp)
  end

  def test_one_liner_with_newline_shouldnt_be_one_line
    assert_equal("<p>foo\nbar</p>", render('%p= "foo\nbar"').chomp)
  end

  def test_end_of_file_multiline
    assert_equal("<p>0</p>\n<p>1</p>\n<p>2</p>\n", render("- for i in (0...3)\n  %p= |\n   i |"))
  end

  def test_cr_newline
    assert_equal("<p>foo</p>\n<p>bar</p>\n<p>baz</p>\n<p>boom</p>\n", render("%p foo\r%p bar\r\n%p baz\n\r%p boom"))
  end

  def test_textareas
    assert_equal("<textarea>Foo&#x000A;  bar&#x000A;   baz</textarea>\n",
                 render('%textarea= "Foo\n  bar\n   baz"'))

    assert_equal("<pre>Foo&#x000A;  bar&#x000A;   baz</pre>\n",
                 render('%pre= "Foo\n  bar\n   baz"'))

    assert_equal("<textarea>#{'a' * 100}</textarea>\n",
                 render("%textarea #{'a' * 100}"))

    assert_equal("<p>\n<textarea>Foo\nBar\nBaz</textarea>\n</p>\n", render(<<SOURCE))
%p
  %textarea
    Foo
    Bar
    Baz
SOURCE
  end

  def test_pre_code
    assert_equal(<<~HTML, render(<<~HAML))
      <pre><code>Foo&#x000A;  bar&#x000A;    baz</code></pre>
    HTML
      %pre
        %code
          :preserve
            Foo
              bar
                baz
    HAML
  end

  def test_indentation_after_dynamic_attr_hash
    assert_equal(<<HTML, render(<<HAML))
<html>
<body>
<img src='test'>
foo
bar
</body>
</html>
HTML
%html
  %body
    %img{:src => 'te'+'st'}
    = "foo\\nbar"
HAML
  end

  def test_whitespace_nuke_with_both_newlines
    assert_equal("<p>\nfoo\n</p>\n", render('%p<= "\nfoo\n"'))
    assert_equal(<<HTML, render(<<HAML))
<p>
<p>
foo
</p>
</p>
HTML
%p
  %p<= "\\nfoo\\n"
HAML
  end
end