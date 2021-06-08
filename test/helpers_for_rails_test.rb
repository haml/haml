# frozen_string_literal: true

require 'test_helper'
require "active_model/naming"

class HelpersForRailsTest < Haml::TestCase
  class FormModel
    extend ActiveModel::Naming
  end

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
    context = ActionView::LookupContext.new(File.expand_path("../templates", __FILE__))
    @base = Class.new(ActionView::Base.try(:with_empty_template_cache) || ActionView::Base) {
      def nested_tag
        content_tag(:span) {content_tag(:div) {"something"}}
      end

      def wacky_form
        form_tag("/foo") {"bar"}
      end
    }.new(context, {post: Post.new("Foo bar\nbaz", nil, PostErrors.new)}, ActionController::Base.new)
  end

  def render(text, options = {})
    return @base.render :inline => text, :type => :haml if options == :action_view
    super
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

  def test_form_tag_in_helper_with_string_block
    def @base.protect_against_forgery?; false; end
    rendered = render('= wacky_form', :action_view)
    fragment = Nokogiri::HTML.fragment(rendered)
    assert_equal 'bar', fragment.text.strip
    assert_equal '/foo', fragment.css('form').first.attributes['action'].to_s
  end

  def test_indented_capture
    assert_equal("  Foo\n  ", @base.render(:inline => "  <% res = capture do %>\n  Foo\n  <% end %><%= res %>"))
  end

  def test_capture_with_string_block
    assert_equal("foo\n", render("= capture { 'foo' }", :action_view))
  end

  def test_capture_with_non_string_value_returns_nil
    def @base.check_capture_returns_nil(&block)
      contents = capture(&block)

      contents << "ERROR" if contents
    end

    assert_equal("\n", render("= check_capture_returns_nil { 2 }", :action_view))
  end

  def test_content_tag_nested
    assert_equal "<span><div>something</div></span>", render("= nested_tag", :action_view).strip
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
end
