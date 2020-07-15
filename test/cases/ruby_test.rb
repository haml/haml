require 'cases/test_base'

# This is for tests that involve the `= some_method` or `-` operators
# The NestedTest is a related set of tests for highly nested cases of Ruby
class RubyTest < TestBase
  def test_plain_equals
    assert_equal("foo\nbar\n", render(<<~HAML))
      = "foo"
      bar
    HAML
  end

  def test_silent_script_with_hyphen_case
    assert_equal("", render("- a = 'foo-case-bar-case'"))
  end

  def test_locals
    assert_equal("<p>Paragraph!</p>\n", render("%p= text", :locals => {:text => "Paragraph!"}))
  end

  def test_silent_script_with_hyphen_end
    assert_equal("", render("- a = 'foo-end-bar-end'"))
  end

  def test_silent_script_with_hyphen_end_and_block
    silence_warnings do
      assert_equal(<<HTML, render(<<HAML))
<p>foo-end</p>
<p>bar-end</p>
HTML
- ("foo-end-bar-end".gsub(/\\w+-end/) do |s|
  %p= s
- end; nil)
HAML
    end
  end

  def test_nil_tag_value_should_render_as_empty
    assert_equal("<p></p>\n", render("%p= nil"))
  end

  def test_tag_with_failed_if_should_render_as_empty
    assert_equal("<p></p>\n", render("%p= 'Hello' if false"))
  end

  def test_ruby_code_should_work_inside_attributes
    assert_equal("<p class='3'>foo</p>", render("%p{:class => 1+2} foo").chomp)
  end

  def test_attributes_with_interpolation
    assert_equal("<iframe id='test' src='http://www.google.com/abc/'></iframe>\n", render(<<-'HAML'))
- base_url = "http://www.google.com"
%iframe#test{src: "#{File.join base_url, '/abc/'}"}
    HAML
  end

  def test_ruby_character_literals_are_not_continuation
    html = ",\n,\n<p>foo</p>\n"
    assert_equal(html, render(<<HAML))
= ?,
= ?\,
%p foo
HAML
  end
end