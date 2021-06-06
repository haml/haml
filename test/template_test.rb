# frozen_string_literal: true

require 'test_helper'
require 'mocks/article'

require 'action_pack/version'
require 'template_test_helper'

class TemplateTest < Haml::TestCase
  TEMPLATES = %w{          very_basic        standard
    original_engine        list             helpful
    silent_script          tag_parsing       just_stuff
    nuke_inner_whitespace  bemit
    escape_safe_buffer}.freeze

  def setup
    @base = create_base

    # filters template uses :sass
    # Sass::Plugin.options.update(:line_comments => true, :style => :compact)
  end

  def create_base
    vars = { 'article' => Article.new, 'foo' => 'value one' }

    context = ActionView::LookupContext.new(TemplateTestHelper::TEMPLATE_PATH)
    base = ActionView::Base.new(context, vars, nil)

    # This is needed by RJS in (at least) Rails 3
    base.instance_variable_set(:@template, base)

    # This is used by form_for.
    # It's usually provided by ActionController::Base.
    def base.protect_against_forgery?; false; end

    def base.compiled_method_container() self.class; end

    base
  end

  def render(text, options = {})
    return @base.render(:inline => text, :type => :haml) if options == :action_view
    options[:format] = :xhtml
    super(text, options, @base)
  end

  def load_result(name)
    @result = ''
    File.new(File.dirname(__FILE__) + "/results/#{name}.xhtml").each_line { |l| @result += l }
    @result
  end

  def assert_renders_correctly(name, &render_method)
    old_options = Haml::Template.options.dup
    Haml::Template.options[:escape_html] = false
    render_method ||= proc { |n| @base.render(template: n) }
    expected = load_result(name)
    actual = if ['silent_script', 'helpful'].include? name
      silence_warnings { render_method[name] }
    else
      render_method[name]
    end

    expected.split("\n").zip(actual.split("\n")).each_with_index do |pair, line|
      message = "template: #{name}\nline:     #{line}"
      assert_equal(pair.first, pair.last, message)
    end
  rescue ActionView::Template::Error => e
    if e.message =~ /Can't run [\w:]+ filter; required (one of|file) ((?:'\w+'(?: or )?)+)(, but none were found| not found)/
      puts "\nCouldn't require #{$2}; skipping a test."
    else
      raise e
    end
  ensure
    Haml::Template.options = old_options
  end

  def test_empty_render_should_remain_empty
    assert_equal('', render(''))
  end

  TEMPLATES.each do |template|
    define_method "test_template_should_render_correctly [template: #{template}]" do
      assert_renders_correctly template
    end
  end

  def test_simple_rendering
    content_to_render = "%p test\n= capture { 'foo' }"
    result = render(content_to_render)
    expected_result = "<p>test</p>\nfoo\n"
    assert_equal(expected_result, result)
  end

  def test_templates_should_render_correctly_with_render_proc
    assert_renders_correctly("standard") do |name|
      engine = Haml::Engine.new(File.read(File.dirname(__FILE__) + "/templates/#{name}.haml"), format: :xhtml)
      engine.render_proc(@base).call
    end
  end

  def test_templates_should_render_correctly_with_def_method
    assert_renders_correctly("standard") do |name|
      engine = Haml::Engine.new(File.read(File.dirname(__FILE__) + "/templates/#{name}.haml"), format: :xhtml)
      engine.def_method(@base, "render_standard")
      @base.render_standard
    end
  end

  def test_instance_variables_should_work_inside_templates
    @base.instance_variable_set(:@content_for_layout, 'something')
    assert_equal("<p>something</p>", render("%p= @content_for_layout").chomp)

    @base.instance_eval("@author = 'Hampton Catlin'")
    assert_equal("<div class='author'>Hampton Catlin</div>", render(".author= @author").chomp)

    @base.instance_eval("@author = 'Hampton'")
    assert_equal("Hampton", render("= @author").chomp)

    @base.instance_eval("@author = 'Catlin'")
    assert_equal("Catlin", render("= @author").chomp)
  end

  def test_precompiled_binary_frozen_string_works
    assert_equal("foo", ::Haml::Engine.new("foo", :encoding=>'BINARY').render(self, {}).chomp)
  end

  def test_instance_variables_should_work_inside_attributes
    @base.instance_eval("@author = 'hcatlin'")
    assert_equal("<p class='hcatlin'>foo</p>", render("%p{:class => @author} foo").chomp)
  end

  def test_template_renders_should_eval
    assert_equal("2\n", render("= 1+1"))
  end

  def test_haml_options
    old_options = Haml::Template.options.dup
    Haml::Template.options[:suppress_eval] = true
    old_base, @base = @base, create_base
    assert_renders_correctly("eval_suppressed")
  ensure
    @base = old_base
    Haml::Template.options = old_options
  end

  ## XSS Protection Tests

  def test_escape_html_option_set
    assert Haml::Template.options[:escape_html]
  end

  def test_xss_protection
    assert_equal("Foo &amp; Bar\n", render('= "Foo & Bar"', :action_view))
  end

  def test_xss_protection_with_safe_strings
    assert_equal("Foo & Bar\n", render('= Haml::Util.html_safe("Foo & Bar")', :action_view))
  end

  def test_xss_protection_with_bang
    assert_equal("Foo & Bar\n", render('!= "Foo & Bar"', :action_view))
  end

  def test_xss_protection_in_interpolation
    assert_equal("Foo &amp; Bar\n", render('Foo #{"&"} Bar', :action_view))
  end

  def test_xss_protection_in_attributes
    assert_equal("<div data-html='&lt;foo&gt;bar&lt;/foo&gt;'></div>\n", render('%div{ "data-html" => "<foo>bar</foo>" }', :action_view))
  end

  def test_xss_protection_with_bang_in_interpolation
    assert_equal("Foo & Bar\n", render('! Foo #{"&"} Bar', :action_view))
  end

  def test_xss_protection_with_safe_strings_in_interpolation
    assert_equal("Foo & Bar\n", render('Foo #{Haml::Util.html_safe("&")} Bar', :action_view))
  end

  ## Regression

  if defined?(ActionView::Helpers::PrototypeHelper)
    def test_rjs
      assert_equal(<<HTML, render(<<HAML, :action_view))
window.location.reload();
HTML
= update_page do |p|
  - p.reload
HAML
    end
  end

  def test_cache
    @base.controller = ActionController::Base.new
    @base.controller.perform_caching = false
    assert_equal(<<HTML, render(<<HAML, :action_view))
Test
HTML
- cache do
  Test
HAML
  end

  class ::TosUnsafeObject; def to_s; '<hr>'; end; end
  class ::TosSafeObject; def to_s; '<hr>'.html_safe; end; end
end
