require 'test_helper'
require "active_model/naming"

class FormModel
  extend ActiveModel::Naming
end

class HelperTest < Haml::TestCase
  TEXT_AREA_CONTENT_REGEX = /<(textarea)[^>]*>\n(.*?)<\/\1>/im

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
    @base = Class.new(ActionView::Base) {
      def nested_tag
        content_tag(:span) {content_tag(:div) {"something"}}
      end

      def wacky_form
        form_tag("/foo") {"bar"}
      end
    }.new
    @base.controller = ActionController::Base.new
    @base.view_paths << File.expand_path("../templates", __FILE__)
    @base.instance_variable_set(:@post, Post.new("Foo bar\nbaz", nil, PostErrors.new))
  end

  def render(text, options = {})
    return @base.render :inline => text, :type => :haml if options == :action_view
    super
  end

  def test_rendering_with_escapes
    def @base.render_something_with_haml_concat
      haml_concat "<p>"
    end
    def @base.render_something_with_haml_tag_and_concat
      haml_tag 'p' do
        haml_concat '<foo>'
      end
    end

    output = render(<<-HAML, :action_view)
- render_something_with_haml_concat
- render_something_with_haml_tag_and_concat
- render_something_with_haml_concat
HAML
    assert_equal("&lt;p&gt;\n<p>\n  &lt;foo&gt;\n</p>\n&lt;p&gt;\n", output)
  end

  def test_with_raw_haml_concat
    haml = <<HAML
- with_raw_haml_concat do
  - haml_concat "<>&"
HAML
    assert_equal("<>&\n", render(haml, :action_view))
  end

  def test_flatten
    assert_equal("FooBar", Haml::Helpers.flatten("FooBar"))

    assert_equal("FooBar", Haml::Helpers.flatten("Foo\rBar"))

    assert_equal("Foo&#x000A;Bar", Haml::Helpers.flatten("Foo\nBar"))

    assert_equal("Hello&#x000A;World!&#x000A;YOU ARE FLAT?&#x000A;OMGZ!",
      Haml::Helpers.flatten("Hello\nWorld!\nYOU ARE \rFLAT?\n\rOMGZ!"))
  end

  def test_list_of_should_render_correctly
    assert_equal("<li>1</li>\n<li>2</li>", render("= list_of([1, 2]) do |i|\n  = i"))
    assert_equal("<li>[1]</li>", render("= list_of([[1]]) do |i|\n  = i.inspect"))
    assert_equal("<li>\n  <h1>Fee</h1>\n  <p>A word!</p>\n</li>\n<li>\n  <h1>Fi</h1>\n  <p>A word!</p>\n</li>\n<li>\n  <h1>Fo</h1>\n  <p>A word!</p>\n</li>\n<li>\n  <h1>Fum</h1>\n  <p>A word!</p>\n</li>",
      render("= list_of(['Fee', 'Fi', 'Fo', 'Fum']) do |title|\n  %h1= title\n  %p A word!"))
    assert_equal("<li c='3'>1</li>\n<li c='3'>2</li>", render("= list_of([1, 2], {:c => 3}) do |i|\n  = i"))
    assert_equal("<li c='3'>[1]</li>", render("= list_of([[1]], {:c => 3}) do |i|\n  = i.inspect"))
    assert_equal("<li c='3'>\n  <h1>Fee</h1>\n  <p>A word!</p>\n</li>\n<li c='3'>\n  <h1>Fi</h1>\n  <p>A word!</p>\n</li>\n<li c='3'>\n  <h1>Fo</h1>\n  <p>A word!</p>\n</li>\n<li c='3'>\n  <h1>Fum</h1>\n  <p>A word!</p>\n</li>",
      render("= list_of(['Fee', 'Fi', 'Fo', 'Fum'], {:c => 3}) do |title|\n  %h1= title\n  %p A word!"))
  end

  def test_buffer_access
    assert(render("= buffer") =~ /#<Haml::Buffer:0x[a-z0-9]+>/)
    assert_equal(render("= (buffer == _hamlout)"), "true\n")
  end

  def test_tabs
    assert_equal("foo\nbar\nbaz\n", render("foo\n- tab_up\nbar\n- tab_down\nbaz"))
    assert_equal("<p>tabbed</p>\n", render("- buffer.tabulation=5\n%p tabbed"))
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
    rescue NoMethodError, ActionView::Template::Error
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
    def @base.protect_against_forgery?; false; end
    rendered = render(<<HAML, :action_view)
= form_tag 'foo' do
 %p bar
 %strong baz
HAML
   fragment = Nokogiri::HTML.fragment(rendered)
   assert_equal 'foo', fragment.css('form').first.attributes['action'].to_s
   assert_equal 'bar', fragment.css('form p').first.text.strip
   assert_equal 'baz', fragment.css('form strong').first.text.strip
  end

  def test_form_for
    # FIXME: current HAML doesn't do proper indentation with form_for (it's the capture { output } in #form_for).
    def @base.protect_against_forgery?; false; end
    rendered = render(<<HAML, :action_view)
= form_for OpenStruct.new, url: 'foo', as: :post do |f|
  = f.text_field :name
HAML
    assert_match(/<(form|div)[^>]+><input/, rendered)
  end

  def test_pre
    assert_equal(%(<pre>Foo bar&#x000A;   baz</pre>\n),
                 render('= content_tag "pre", "Foo bar\n   baz"', :action_view))
  end

  def test_text_area_tag
    output = render('= text_area_tag "body", "Foo\nBar\n Baz\n   Boom"', :action_view)
    match_data = output.match(TEXT_AREA_CONTENT_REGEX)
    assert_equal "Foo&#x000A;Bar&#x000A; Baz&#x000A;   Boom", match_data[2]
  end

  def test_text_area
    output = render('= text_area :post, :body', :action_view)
    match_data = output.match(TEXT_AREA_CONTENT_REGEX)
    assert_equal "Foo bar&#x000A;baz", match_data[2]
  end

  def test_partials_should_not_cause_textareas_to_be_indented
    # non-indentation of textareas rendered inside partials
    @base.instance_variable_set(:@post, Post.new("Foo", nil, PostErrors.new))
    output = render(".foo\n  .bar\n    = render '/text_area_helper'", :action_view)
    match_data = output.match(TEXT_AREA_CONTENT_REGEX)
    assert_equal 'Foo', match_data[2]
  end

  def test_textareas_should_preserve_leading_whitespace
    # leading whitespace preservation
    @base.instance_variable_set(:@post, Post.new("    Foo", nil, PostErrors.new))
    output = render(".foo\n  = text_area :post, :body", :action_view)
    match_data = output.match(TEXT_AREA_CONTENT_REGEX)
    assert_equal '&#x0020;   Foo', match_data[2]
  end

  def test_textareas_should_preserve_leading_whitespace_in_partials
    # leading whitespace in textareas rendered inside partials
    @base.instance_variable_set(:@post, Post.new("    Foo", nil, PostErrors.new))
    output = render(".foo\n  .bar\n    = render '/text_area_helper'", :action_view)
    match_data = output.match(TEXT_AREA_CONTENT_REGEX)
    assert_equal '&#x0020;   Foo', match_data[2]
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
    rendered = render('= wacky_form', :action_view)
    fragment = Nokogiri::HTML.fragment(rendered)
    assert_equal 'bar', fragment.text.strip
    assert_equal '/foo', fragment.css('form').first.attributes['action'].to_s
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

  def test_haml_tag_autoclosed_tags_are_closed_xhtml
    assert_equal("<br class='foo' />\n", render("- haml_tag :br, :class => 'foo'", :format => :xhtml))
  end

  def test_haml_tag_autoclosed_tags_are_closed_html
    assert_equal("<br class='foo'>\n", render("- haml_tag :br, :class => 'foo'", :format => :html5))
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
    assert_equal("<p />\n", render("- haml_tag :p, :/", :format => :xhtml))
    assert_equal("<p>\n", render("- haml_tag :p, :/", :format => :html5))
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

  def test_haml_concat_inside_haml_tag_escaped_with_xss
    assert_equal("<p>\n  &lt;&gt;&amp;\n</p>\n", render(<<HAML, :action_view))
- haml_tag :p do
  - haml_concat "<>&"
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

  def test_haml_tag
    assert_equal(<<HTML, render(<<HAML))
<p>
  <strong>Hi!</strong>
</p>
HTML
- haml_tag :p do
  - haml_tag :strong, "Hi!"
HAML
  end

  def test_haml_tag_if_positive
    assert_equal(<<HTML, render(<<HAML))
<div class='conditional'>
<p>A para</p>
</div>
HTML
- haml_tag_if true, '.conditional' do
  %p A para
HAML
  end

  def test_haml_tag_if_positive_with_attributes
    assert_equal(<<HTML, render(<<HAML))
<div class='conditional' foo='bar'>
<p>A para</p>
</div>
HTML
- haml_tag_if true, '.conditional',  {:foo => 'bar'} do
  %p A para
HAML
  end

  def test_haml_tag_if_negative
    assert_equal(<<HTML, render(<<HAML))
<p>A para</p>
HTML
- haml_tag_if false, '.conditional' do
  %p A para
HAML
  end

  def test_haml_tag_if_error_return
    assert_raises(Haml::Error) { render("= haml_tag_if false, '.conditional' do\n  %p Hello") }
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
    obj = Object.new
    def obj.trc(collection, &block)
      collection.each do |record|
        haml_concat capture_haml(record, &block)
      end
    end

    assert_equal("1\n\n2\n\n3\n\n", render("- trc([1, 2, 3]) do |i|\n  = i.inspect", scope: obj))
  end

  def test_capture_with_string_block
    assert_equal("foo\n", render("= capture { 'foo' }", :action_view))
  end

  def test_capture_with_non_string_value_reurns_nil
    def @base.check_capture_returns_nil(&block)
      contents = capture(&block)

      contents << "ERROR" if contents
    end

    assert_equal("\n", render("= check_capture_returns_nil { 2 }", :action_view))
  end


  class HomemadeViewContext
    include ActionView::Context
    include ActionView::Helpers::FormHelper

    def initialize
      _prepare_context
    end

    def url_for(*)
      "/"
    end

    def dom_class(*)
    end

    def dom_id(*)
    end

    def m # I have to inject the model into the view using an instance method, using locals doesn't work.
      FormModel.new
    end

    def protect_against_forgery?
    end

    # def capture(*args, &block)
    #   capture_haml(*args, &block)
    # end
  end

  def test_form_for_with_homemade_view_context
    handler  = ActionView::Template.handler_for_extension("haml")
    template = ActionView::Template.new(<<HAML, "inline template", handler, {})
= form_for(m, :url => "/") do
  %b Bold!
HAML

    # see if Bold is within form tags:
    assert_match(/<form.*>.*<b>Bold!<\/b>.*<\/form>/m, template.render(HomemadeViewContext.new, {}))
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
    assert_equal("<pre>Foo&#x000A;Bar</pre>&#x000A;Foo&#x000A;Bar",
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
    render("%p foo\n= haml_concat('foo').to_s\n%p bar")
    assert false, "Expected Haml::Error"
  rescue Haml::Error => e
    assert_equal 2, e.backtrace[0].scan(/:(\d+)/).first.first.to_i
  end

  def test_error_return_line_in_helper
    obj = Object.new
    def obj.something_that_uses_haml_concat
      haml_concat('foo').to_s
    end

    render("- something_that_uses_haml_concat", scope: obj)
    assert false, "Expected Haml::Error"
  rescue Haml::Error => e
    assert_equal __LINE__ - 6, e.backtrace[0].scan(/:(\d+)/).first.first.to_i
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

  def test_html_escape_should_work_on_frozen_strings
    begin
      assert Haml::Helpers.html_escape('foo'.freeze)
    rescue => e
      flunk e.message
    end
  end

  def test_html_escape_encoding
    old_stderr, $stderr = $stderr, StringIO.new
    string = "\"><&\u00e9" # if you're curious, u00e9 is "LATIN SMALL LETTER E WITH ACUTE"
    assert_equal "&quot;&gt;&lt;&amp;\u00e9", Haml::Helpers.html_escape(string)
    assert $stderr.string == "", "html_escape shouldn't generate warnings with UTF-8 strings: #{$stderr.string}"
  ensure
    $stderr = old_stderr
  end

  def test_html_escape_non_string
    assert_equal('4.58', Haml::Helpers.html_escape(4.58))
    assert_equal('4.58', Haml::Helpers.html_escape_without_haml_xss(4.58))
  end

  def test_escape_once
    assert_equal "&quot;&gt;&lt;&amp;", Haml::Helpers.escape_once('"><&')
  end

  def test_escape_once_leaves_entity_references
    assert_equal "&quot;&gt;&lt;&amp; &nbsp;", Haml::Helpers.escape_once('"><& &nbsp;')
  end

  def test_escape_once_leaves_numeric_references
    assert_equal "&quot;&gt;&lt;&amp; &#160;", Haml::Helpers.escape_once('"><& &#160;') #decimal
    assert_equal "&quot;&gt;&lt;&amp; &#x00a0;", Haml::Helpers.escape_once('"><& &#x00a0;') #hexadecimal
  end

  def test_escape_once_encoding
    old_stderr, $stderr = $stderr, StringIO.new
    string = "\"><&\u00e9 &nbsp;"
    assert_equal "&quot;&gt;&lt;&amp;\u00e9 &nbsp;", Haml::Helpers.escape_once(string)
    assert $stderr.string == "", "html_escape shouldn't generate warnings with UTF-8 strings: #{$stderr.string}"
  ensure
    $stderr = old_stderr
  end

  def test_html_attrs_xhtml
    assert_equal("<html lang='en-US' xml:lang='en-US' xmlns='http://www.w3.org/1999/xhtml'></html>\n",
                  render("%html{html_attrs}", :format => :xhtml))
  end

  def test_html_attrs_html4
    assert_equal("<html lang='en-US'></html>\n",
                  render("%html{html_attrs}", :format => :html4))
  end

  def test_html_attrs_html5
    assert_equal("<html lang='en-US'></html>\n",
                  render("%html{html_attrs}", :format => :html5))
  end

  def test_html_attrs_xhtml_other_lang
    assert_equal("<html lang='es-AR' xml:lang='es-AR' xmlns='http://www.w3.org/1999/xhtml'></html>\n",
                  render("%html{html_attrs('es-AR')}", :format => :xhtml))
  end

  def test_html_attrs_html4_other_lang
    assert_equal("<html lang='es-AR'></html>\n",
                  render("%html{html_attrs('es-AR')}", :format => :html4))
  end

  def test_html_attrs_html5_other_lang
    assert_equal("<html lang='es-AR'></html>\n",
                  render("%html{html_attrs('es-AR')}", :format => :html5))
  end

  def test_escape_once_should_work_on_frozen_strings
    begin
      Haml::Helpers.escape_once('foo'.freeze)
    rescue => e
      flunk e.message
    end
  end

end
