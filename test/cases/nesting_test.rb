
require 'cases/test_base'

class NestingTest < TestBase
  def test_if_without_content_and_else
    assert_equal(<<HTML, render(<<HAML))
foo
HTML
- if false
- else
  foo
HAML

    assert_equal(<<HTML, render(<<HAML))
foo
HTML
- if true
  - if false
  - else
    foo
HAML
  end

  def test_case_assigned_to_var
    assert_equal(<<HTML, render(<<HAML))
bar
HTML
- var = case 12
- when 1; "foo"
- when 12; "bar"
= var
HAML

    assert_equal(<<HTML, render(<<HAML))
bar
HTML
- var = case 12
- when 1
  - "foo"
- when 12
  - "bar"
= var
HAML

    assert_equal(<<HTML, render(<<HAML))
bar
HTML
- var = case 12
  - when 1
    - "foo"
  - when 12
    - "bar"
= var
HAML
  end

  def test_nested_case_assigned_to_var
    assert_equal(<<HTML, render(<<HAML))
bar
HTML
- if true
  - var = case 12
  - when 1; "foo"
  - when 12; "bar"
  = var
HAML
  end

  def test_case_assigned_to_multiple_vars
    assert_equal(<<HTML, render(<<HAML))
bar
bip
HTML
- var, vip = case 12
- when 1; ["foo", "baz"]
- when 12; ["bar", "bip"]
= var
= vip
HAML
  end

  def test_if_assigned_to_var
    assert_equal(<<HTML, render(<<HAML))
foo
HTML
- var = if false
- else
  - "foo"
= var
HAML

    assert_equal(<<HTML, render(<<HAML))
foo
HTML
- var = if false
- elsif 12 == 12
  - "foo"
- elsif 14 == 14; "bar"
- else
  - "baz"
= var
HAML

    assert_equal(<<HTML, render(<<HAML))
foo
HTML
- var = if false
  - "bar"
- else
  - "foo"
= var
HAML
  end

  def test_case_with_newline_after_case
    assert_equal(<<HTML, render(<<HAML))
foo
HTML
- case 1

  - when 1
    foo
  - when 2
    bar
HAML

    assert_equal(<<HTML, render(<<HAML))
bar
HTML
- case 2

- when 1
  foo
- when 2
  bar
HAML
  end

  def test_nested_end_with_method_call
    assert_equal(<<HTML, render(<<HAML))
<p>
2|3|4b-a-r</p>
HTML
%p
  = [1, 2, 3].map do |i|
    - i + 1
  - end.join("|")
  = "bar".gsub(/./) do |s|
    - s + "-"
  - end.gsub(/-$/) do |s|
    - ''
HAML
  end

  def test_silent_end_with_stuff
    assert_equal(<<HTML, render(<<HAML))
e
d
c
b
a
HTML
- str = +"abcde"
- if true
  = str.slice!(-1).chr
- end until str.empty?
HAML

    assert_equal(<<HTML, render(<<HAML))
<p>hi!</p>
HTML
- if true
  %p hi!
- end if "foo".gsub(/f/) do
  - "z"
- end + "bar"
HAML
  end

  def test_inline_if
    assert_equal(<<HTML, render(<<HAML))
<p>One</p>
<p></p>
<p>Three</p>
HTML
- for name in ["One", "Two", "Three"]
  %p= name unless name == "Two"
HAML
  end

  def test_end_with_method_call
    assert_equal("2|3|4b-a-r", render(<<HAML))
= [1, 2, 3].map do |i|
  - i + 1
- end.join("|")
= "bar".gsub(/./) do |s|
  - s + "-"
- end.gsub(/-$/) do |s|
  - ''
HAML
  end

  def test_equals_block
    assert_equal("foo\n", render(<<HAML))
= capture_haml do
  foo
HAML
  end

  def test_both_case_indentation_work_with_deeply_nested_code
    result = <<RESULT
<h2>
other
</h2>
RESULT
    assert_equal(result, render(<<HAML))
- case 'other'
- when 'test'
  %h2
    hi
- when 'other'
  %h2
    other
HAML
    assert_equal(result, render(<<~HAML))
- case 'other'
  - when 'test'
    %h2
      hi
  - when 'other'
    %h2
      other
    HAML
  end

  def test_block_spacing
    assert render(<<-HAML)
- foo = ["bar", "baz", "kni"]
- foo.each do | item |
  = item
    HAML
  rescue ::SyntaxError
    flunk("Should not have raised syntax error")
  end
end