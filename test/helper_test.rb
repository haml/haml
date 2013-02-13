require 'test_helper'

class ActionView::Base
  def nested_tag
    content_tag(:span) {content_tag(:div) {"something"}}
  end

  def wacky_form
    form_tag("/foo") {"bar"}
  end
end

module Haml::Helpers
  def something_that_uses_haml_concat
    haml_concat('foo').to_s
  end
end

class HelperTest < MiniTest::Unit::TestCase
  Post = Struct.new('Post', :body, :error_field, :errors)
  class PostErrors
    def on(name)
      return unless name == 'error_field'
      ["Really bad error"]
    end
    alias_method :full_messages, :on

    def [](name)
      on(name) || []
    end
  end

  def setup
    @base = ActionView::Base.new
    @base.controller = ActionController::Base.new

    if defined?(ActionController::Response)
      # This is needed for >=3.0.0
      @base.controller.response = ActionController::Response.new
    end

    @base.instance_variable_set('@post', Post.new("Foo bar\nbaz", nil, PostErrors.new))
  end

  def render(text, options = {})
    return @base.render :inline => text, :type => :haml if options == :action_view
    super
  end

  def test_flatten
    assert_equal("FooBar", Haml::Helpers.flatten("FooBar"))

    assert_equal("FooBar", Haml::Helpers.flatten("Foo\rBar"))

    assert_equal("Foo&#x000A;Bar", Haml::Helpers.flatten("Foo\nBar"))

    assert_equal("Hello&#x000A;World!&#x000A;YOU ARE FLAT?&#x000A;OMGZ!",
      Haml::Helpers.flatten("Hello\nWorld!\nYOU ARE \rFLAT?\n\rOMGZ!"))
  end

  def test_list_of_should_render_correctly
    assert_equal("<li>1</li>\n<li>2</li>\n", render("= list_of([1, 2]) do |i|\n  = i"))
    assert_equal("<li>[1]</li>\n", render("= list_of([[1]]) do |i|\n  = i.inspect"))
    assert_equal("<li>\n  <h1>Fee</h1>\n  <p>A word!</p>\n</li>\n<li>\n  <h1>Fi</h1>\n  <p>A word!</p>\n</li>\n<li>\n  <h1>Fo</h1>\n  <p>A word!</p>\n</li>\n<li>\n  <h1>Fum</h1>\n  <p>A word!</p>\n</li>\n",
      render("= list_of(['Fee', 'Fi', 'Fo', 'Fum']) do |title|\n  %h1= title\n  %p A word!"))
    assert_equal("<li c='3'>1</li>\n<li c='3'>2</li>\n", render("= list_of([1, 2], {:c => 3}) do |i|\n  = i"))
    assert_equal("<li c='3'>[1]</li>\n", render("= list_of([[1]], {:c => 3}) do |i|\n  = i.inspect"))
    assert_equal("<li c='3'>\n  <h1>Fee</h1>\n  <p>A word!</p>\n</li>\n<li c='3'>\n  <h1>Fi</h1>\n  <p>A word!</p>\n</li>\n<li c='3'>\n  <h1>Fo</h1>\n  <p>A word!</p>\n</li>\n<li c='3'>\n  <h1>Fum</h1>\n  <p>A word!</p>\n</li>\n",
      render("= list_of(['Fee', 'Fi', 'Fo', 'Fum'], {:c => 3}) do |title|\n  %h1= title\n  %p A word!"))
  end

  def test_buffer_access
    assert(render("= buffer") =~ /#<Haml::Buffer:0x[a-z0-9]+>/)
    assert_equal(render("= (buffer == _hamlout)"), "true\n")
  end

  def test_tabs
    assert_equal("foo\n  bar\nbaz\n", render("foo\n- tab_up\nbar\n- tab_down\nbaz"))
    assert_equal("          <p>tabbed</p>\n", render("- buffer.tabulation=5\n%p tabbed"))
  end

  def test_with_tabs
    assert_equal(<<HTML, render(<<HAML))
Foo
    Bar
    Baz
Baz
HTML
Foo
- with_tabs 2 do
  = "Bar\\nBaz"
Baz
HAML
  end

  def test_helpers_dont_leak
    # Haml helpers shouldn't be accessible from ERB
    render("foo")
    proper_behavior = false

    begin
      ActionView::Base.new.render(:inline => "<%= flatten('Foo\\nBar') %>")
    rescue NoMethodError, Haml::Util.av_template_class(:Error)
      proper_behavior = true
    end
    assert(proper_behavior)

    begin
      ActionView::Base.new.render(:inline => "<%= concat('foo') %>")
    rescue ArgumentError, NameError
      proper_behavior = true
    end
    assert(proper_behavior)
  end

  def test_action_view_included
    assert(Haml::Helpers.action_view?)
  end

  def test_form_tag
    # This is usually provided by ActionController::Base.
    def @base.protect_against_forgery?; false; end
    assert_equal(<<HTML, render(<<HAML, :action_view))
<form accept-charset="UTF-8" action="foo" method="post">#{rails_form_opener}
  <p>bar</p>
  <strong>baz</strong>
</form>
HTML
= form_tag 'foo' do
  %p bar
  %strong baz
HAML
  end

  if ActionPack::VERSION::MAJOR == 4
    def test_text_area
      assert_equal(%(<textarea id="body" name="body">\nFoo&#x000A;Bar&#x000A; Baz&#x000A;   Boom</textarea>\n),
                   render('= text_area_tag "body", "Foo\nBar\n Baz\n   Boom"', :action_view))

      assert_equal(%(<textarea id="post_body" name="post[body]">\nFoo bar&#x000A;baz</textarea>\n),
                   render('= text_area :post, :body', :action_view))

      assert_equal(%(<pre>Foo bar&#x000A;   baz</pre>\n),
                   render('= content_tag "pre", "Foo bar\n   baz"', :action_view))
    end
  elsif (ActionPack::VERSION::MAJOR == 3) && (ActionPack::VERSION::MINOR >= 2) && (ActionPack::VERSION::TINY >= 3)
    def test_text_area
      assert_equal(%(<textarea id="body" name="body">\nFoo&#x000A;Bar&#x000A; Baz&#x000A;   Boom</textarea>\n),
                   render('= text_area_tag "body", "Foo\nBar\n Baz\n   Boom"', :action_view))

      assert_equal(%(<textarea cols="40" id="post_body" name="post[body]" rows="20">\nFoo bar&#x000A;baz</textarea>\n),
                   render('= text_area :post, :body', :action_view))

      assert_equal(%(<pre>Foo bar&#x000A;   baz</pre>\n),
                   render('= content_tag "pre", "Foo bar\n   baz"', :action_view))
    end
  else
    def test_text_area
      assert_equal(%(<textarea id="body" name="body">Foo&#x000A;Bar&#x000A; Baz&#x000A;   Boom</textarea>\n),
                   render('= text_area_tag "body", "Foo\nBar\n Baz\n   Boom"', :action_view))

      assert_equal(%(<textarea cols="40" id="post_body" name="post[body]" rows="20">Foo bar&#x000A;baz</textarea>\n),
                   render('= text_area :post, :body', :action_view))

      assert_equal(%(<pre>Foo bar&#x000A;   baz</pre>\n),
                   render('= content_tag "pre", "Foo bar\n   baz"', :action_view))
    end
  end

  def test_capture_haml
    assert_equal(<<HTML, render(<<HAML))
"<p>13</p>\\n"
HTML
- (foo = capture_haml(13) do |a|
  %p= a
- end)
= foo.inspect
HAML
  end

  def test_content_tag_block
    assert_equal(<<HTML.strip, render(<<HAML, :action_view).strip)
<div><p>bar</p>
<strong>bar</strong>
</div>
HTML
= content_tag :div do
  %p bar
  %strong bar
HAML
  end

  def test_content_tag_error_wrapping
    def @base.protect_against_forgery?; false; end
    output = render(<<HAML, :action_view)
= form_for @post, :as => :post, :html => {:class => nil, :id => nil}, :url => '' do |f|
  = f.label 'error_field'
HAML
    fragment = Nokogiri::HTML.fragment(output)
    refute_nil fragment.css('form div.field_with_errors label[for=post_error_field]').first
  end

  def test_form_tag_in_helper_with_string_block
    def @base.protect_against_forgery?; false; end
    assert_equal(<<HTML, render(<<HAML, :action_view))
<form accept-charset="UTF-8" action="/foo" method="post">#{rails_form_opener}bar</form>
HTML
= wacky_form
HAML
  end

  def test_haml_tag_name_attribute_with_id
    assert_equal("<p id='some_id'></p>\n", render("- haml_tag 'p#some_id'"))
  end

  def test_haml_tag_name_attribute_with_colon_id
    assert_equal("<p id='some:id'></p>\n", render("- haml_tag 'p#some:id'"))
  end

  def test_haml_tag_without_name_but_with_id
    assert_equal("<div id='some_id'></div>\n", render("- haml_tag '#some_id'"))
  end

  def test_haml_tag_without_name_but_with_class
    assert_equal("<div class='foo'></div>\n", render("- haml_tag '.foo'"))
  end

  def test_haml_tag_without_name_but_with_colon_class
    assert_equal("<div class='foo:bar'></div>\n", render("- haml_tag '.foo:bar'"))
  end

  def test_haml_tag_name_with_id_and_class
    assert_equal("<p class='foo' id='some_id'></p>\n", render("- haml_tag 'p#some_id.foo'"))
  end

  def test_haml_tag_name_with_class
    assert_equal("<p class='foo'></p>\n", render("- haml_tag 'p.foo'"))
  end

  def test_haml_tag_name_with_class_and_id
    assert_equal("<p class='foo' id='some_id'></p>\n", render("- haml_tag 'p.foo#some_id'"))
  end

  def test_haml_tag_name_with_id_and_multiple_classes
    assert_equal("<p class='foo bar' id='some_id'></p>\n", render("- haml_tag 'p#some_id.foo.bar'"))
  end

  def test_haml_tag_name_with_multiple_classes_and_id
    assert_equal("<p class='foo bar' id='some_id'></p>\n", render("- haml_tag 'p.foo.bar#some_id'"))
  end

  def test_haml_tag_name_and_attribute_classes_merging_with_id
    assert_equal("<p class='bar foo' id='some_id'></p>\n", render("- haml_tag 'p#some_id.foo', :class => 'bar'"))
  end

  def test_haml_tag_name_and_attribute_classes_merging
    assert_equal("<p class='bar foo'></p>\n", render("- haml_tag 'p.foo', :class => 'bar'"))
  end

  def test_haml_tag_name_merges_id_and_attribute_id
    assert_equal("<p id='foo_bar'></p>\n", render("- haml_tag 'p#foo', :id => 'bar'"))
  end

  def test_haml_tag_attribute_html_escaping
    assert_equal("<p id='foo&amp;bar'>baz</p>\n", render("%p{:id => 'foo&bar'} baz", :escape_html => true))
  end

  def test_haml_tag_autoclosed_tags_are_closed
    assert_equal("<br class='foo' />\n", render("- haml_tag :br, :class => 'foo'"))
  end

  def test_haml_tag_with_class_array
    assert_equal("<p class='a b'>foo</p>\n", render("- haml_tag :p, 'foo', :class => %w[a b]"))
    assert_equal("<p class='a b c d'>foo</p>\n", render("- haml_tag 'p.c.d', 'foo', :class => %w[a b]"))
  end

  def test_haml_tag_with_id_array
    assert_equal("<p id='a_b'>foo</p>\n", render("- haml_tag :p, 'foo', :id => %w[a b]"))
    assert_equal("<p id='c_a_b'>foo</p>\n", render("- haml_tag 'p#c', 'foo', :id => %w[a b]"))
  end

  def test_haml_tag_with_data_hash
    assert_equal("<p data-baz data-foo='bar'>foo</p>\n",
      render("- haml_tag :p, 'foo', :data => {:foo => 'bar', :baz => true}"))
  end

  def test_haml_tag_non_autoclosed_tags_arent_closed
    assert_equal("<p></p>\n", render("- haml_tag :p"))
  end

  def test_haml_tag_renders_text_on_a_single_line
    assert_equal("<p>#{'a' * 100}</p>\n", render("- haml_tag :p, 'a' * 100"))
  end

  def test_haml_tag_raises_error_for_multiple_content
    assert_raises(Haml::Error) { render("- haml_tag :p, 'foo' do\n  bar") }
  end

  def test_haml_tag_flags
    assert_equal("<p />\n", render("- haml_tag :p, :/"))
    assert_equal("<p>kumquat</p>\n", render("- haml_tag :p, :< do\n  kumquat"))

    assert_raises(Haml::Error) { render("- haml_tag :p, 'foo', :/") }
    assert_raises(Haml::Error) { render("- haml_tag :p, :/ do\n  foo") }
  end

  def test_haml_tag_error_return
    assert_raises(Haml::Error) { render("= haml_tag :p") }
  end

  def test_haml_tag_with_multiline_string
    assert_equal(<<HTML, render(<<HAML))
<p>
  foo
  bar
  baz
</p>
HTML
- haml_tag :p, "foo\\nbar\\nbaz"
HAML
  end

  def test_haml_concat_with_multiline_string
    assert_equal(<<HTML, render(<<HAML))
<p>
  foo
  bar
  baz
</p>
HTML
%p
  - haml_concat "foo\\nbar\\nbaz"
HAML
  end

  def test_haml_tag_with_ugly
    assert_equal(<<HTML, render(<<HAML, :ugly => true))
<p>
<strong>Hi!</strong>
</p>
HTML
- haml_tag :p do
  - haml_tag :strong, "Hi!"
HAML
  end

  def test_is_haml
    assert(!ActionView::Base.new.is_haml?)
    assert_equal("true\n", render("= is_haml?"))
    assert_equal("true\n", render("= is_haml?", :action_view))
    assert_equal("false", @base.render(:inline => '<%= is_haml? %>'))
    assert_equal("false\n", render("= render :inline => '<%= is_haml? %>'", :action_view))
  end

  def test_page_class
    controller = Struct.new(:controller_name, :action_name).new('troller', 'tion')
    scope = Struct.new(:controller).new(controller)
    result = render("%div{:class => page_class} MyDiv", :scope => scope)
    expected = "<div class='troller tion'>MyDiv</div>\n"
    assert_equal expected, result
  end

  def test_indented_capture
    assert_equal("  Foo\n  ", @base.render(:inline => "  <% res = capture do %>\n  Foo\n  <% end %><%= res %>"))
  end

  def test_capture_deals_properly_with_collections
    Haml::Helpers.module_eval do
      def trc(collection, &block)
        collection.each do |record|
          haml_concat capture_haml(record, &block)
        end
      end
    end

    assert_equal("1\n\n2\n\n3\n\n", render("- trc([1, 2, 3]) do |i|\n  = i.inspect"))
  end

  def test_capture_with_string_block
    assert_equal("foo\n", render("= capture { 'foo' }", :action_view))
  end

  def test_find_and_preserve_with_block
    assert_equal("<pre>Foo&#x000A;Bar</pre>\nFoo\nBar\n",
                 render("= find_and_preserve do\n  %pre\n    Foo\n    Bar\n  Foo\n  Bar"))
  end

  def test_find_and_preserve_with_block_and_tags
    assert_equal("<pre>Foo\nBar</pre>\nFoo\nBar\n",
                 render("= find_and_preserve([]) do\n  %pre\n    Foo\n    Bar\n  Foo\n  Bar"))
  end

  def test_preserve_with_block
    assert_equal("<pre>Foo&#x000A;Bar</pre>&#x000A;Foo&#x000A;Bar\n",
                 render("= preserve do\n  %pre\n    Foo\n    Bar\n  Foo\n  Bar"))
  end

  def test_init_haml_helpers
    context = Object.new
    class << context
      include Haml::Helpers
    end
    context.init_haml_helpers

    result = context.capture_haml do
      context.haml_tag :p, :attr => "val" do
        context.haml_concat "Blah"
      end
    end

    assert_equal("<p attr='val'>\n  Blah\n</p>\n", result)
  end

  def test_non_haml
    assert_equal("false\n", render("= non_haml { is_haml? }"))
  end

  def test_content_tag_nested
    assert_equal "<span><div>something</div></span>", render("= nested_tag", :action_view).strip
  end

  def test_error_return
    assert_raises(Haml::Error, <<MESSAGE) {render("= haml_concat 'foo'")}
haml_concat outputs directly to the Haml template.
Disregard its return value and use the - operator,
or use capture_haml to get the value as a String.
MESSAGE
  end

  def test_error_return_line
    render("%p foo\n= haml_concat 'foo'\n%p bar")
    assert false, "Expected Haml::Error"
  rescue Haml::Error => e
    assert_equal 2, e.backtrace[1].scan(/:(\d+)/).first.first.to_i
  end

  def test_error_return_line_in_helper
    render("- something_that_uses_haml_concat")
    assert false, "Expected Haml::Error"
  rescue Haml::Error => e
    assert_equal 15, e.backtrace[0].scan(/:(\d+)/).first.first.to_i
  end

  class ActsLikeTag
    # We want to be able to have people include monkeypatched ActionView helpers
    # without redefining is_haml?.
    # This is accomplished via Object#is_haml?, and this is a test for it.
    include ActionView::Helpers::TagHelper
    def to_s
      content_tag :p, 'some tag content'
    end
  end

  def test_random_class_includes_tag_helper
    assert_equal "<p>some tag content</p>", ActsLikeTag.new.to_s
  end

  def test_capture_with_nuke_outer
    assert_equal "<div></div>\n*<div>hi there!</div>\n", render(<<HAML)
%div
= precede("*") do
  %div> hi there!
HAML

    assert_equal "<div></div>\n*<div>hi there!</div>\n", render(<<HAML)
%div
= precede("*") do
  = "  "
  %div> hi there!
HAML
  end

  def test_html_escape
    assert_equal "&quot;&gt;&lt;&amp;", Haml::Helpers.html_escape('"><&')
  end

  def test_html_escape_encoding
    old_stderr, $stderr = $stderr, StringIO.new
    string = "\"><&\u00e9" # if you're curious, u00e9 is "LATIN SMALL LETTER E WITH ACUTE"
    assert_equal "&quot;&gt;&lt;&amp;\u00e9", Haml::Helpers.html_escape(string)
    assert $stderr.string == "", "html_escape shouldn't generate warnings with UTF-8 strings: #{$stderr.string}"
  ensure
    $stderr = old_stderr
  end

  def test_escape_once
    assert_equal "&quot;&gt;&lt;&amp;", Haml::Helpers.escape_once('"><&')
  end

  def test_escape_once_leaves_entity_references
    assert_equal "&quot;&gt;&lt;&amp; &nbsp;", Haml::Helpers.escape_once('"><& &nbsp;')
  end

  def test_escape_once_leaves_numeric_references
    assert_equal "&quot;&gt;&lt;&amp; &#160;", Haml::Helpers.escape_once('"><& &#160;') #decimal
    #assert_equal "&quot;&gt;&lt;&amp; &#x00a0;", Haml::Helpers.escape_once('"><& &#x00a0;') #hexadecimal
  end

  def test_escape_once_encoding
    old_stderr, $stderr = $stderr, StringIO.new
    string = "\"><&\u00e9 &nbsp;"
    assert_equal "&quot;&gt;&lt;&amp;\u00e9 &nbsp;", Haml::Helpers.escape_once(string)
    assert $stderr.string == "", "html_escape shouldn't generate warnings with UTF-8 strings: #{$stderr.string}"
  ensure
    $stderr = old_stderr
  end

end

