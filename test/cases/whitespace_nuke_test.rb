
require 'cases/test_base'

# The use of `<` to remove whitespace
# @TODO Revisit if we should... ahem, rename this function
class WhiteSpaceNuke < TestBase
  def test_nuke_inner_whitespace_in_loops
    assert_equal(<<HTML, render(<<HAML))
<ul>foobarbaz</ul>
HTML
%ul<
  - for str in %w[foo bar baz]
    = str
HAML
  end

  def test_both_whitespace_nukes_work_together
    assert_equal(<<RESULT, render(<<SOURCE))
<p><q>Foo
Bar</q></p>
RESULT
%p
  %q><= "Foo\\nBar"
SOURCE
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

  def test_whitespace_nuke_with_tags_and_else
    assert_equal(<<HTML, render(<<HAML))
<a>
<b>foo</b>
</a>
HTML
%a
  %b<
    - if false
      = "foo"
    - else
      foo
HAML

    assert_equal(<<HTML, render(<<HAML))
<a>
<b>
foo
</b>
</a>
HTML
%a
  %b
    - if false
      = "foo"
    - else
      foo
HAML
  end

  def test_outer_whitespace_nuke_with_empty_script
    assert_equal(<<HTML, render(<<HAML))
<p>
foo  <a></a></p>
HTML
%p
  foo
  = "  "
  %a>
HAML
  end

  def test_remove_whitespace_true
    assert_equal("<div id='outer'><div id='inner'><p>hello world</p></div></div>",
                 render("#outer\n  #inner\n    %p hello world", :remove_whitespace => true))
    assert_equal("<p>hello world<pre>foo   bar\nbaz</pre></p>", render(<<HAML, :remove_whitespace => true))
%p
  hello world
  %pre
    foo   bar
    baz
HAML
    assert_equal("<div><span>foo</span> <span>bar</span></div>",
                 render('%div <span>foo</span> <span>bar</span>', :remove_whitespace => true))
  end
end