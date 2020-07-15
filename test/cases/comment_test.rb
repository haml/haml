require 'cases/test_base'

class CommentTest < TestBase
  def test_single_line_comments_are_interpolated
    assert_equal("<!-- Hello 2 -->\n",
                 render('/ Hello #{1 + 1}'))
  end

  def test_single_line_comments_are_not_interpolated_with_suppress_eval
    assert_equal("<!--  -->\n",
                 render('/ Hello #{1 + 1}', :suppress_eval => true))
  end

  def test_single_line_comments_with_interpolation_dont_break_tabulation
    assert_equal("<!-- Hello 2 -->\nconcatted\n",
                 render("/ Hello \#{1 + 1}\n- haml_concat 'concatted'"))
  end

  def test_balanced_conditional_comments
    assert_equal("<!--[if !(IE 6)|(IE 7)]> Bracket: ] <![endif]-->\n",
                 render("/[if !(IE 6)|(IE 7)] Bracket: ]"))
  end

  def test_downlevel_revealed_conditional
    assert_equal("<!--[if !IE]><!--> A comment <!--<![endif]-->\n",
                 render("/![if !IE] A comment"))
  end

  def test_downlevel_revealed_conditional_comments_block
    assert_equal("<!--[if !IE]><!-->\nA comment\n<!--<![endif]-->\n",
                 render("/![if !IE]\n  A comment"))
  end


  def test_comment_with_crazy_nesting
    assert_equal(<<HTML, render(<<HAML))
foo
bar
HTML
foo
-#
  ul
    %li{
  foo
bar
HAML
  end
end