require 'test_helper'
require 'haml/mocks/article'

require 'action_pack/version'
require 'hamlit/rails_template'

module Haml::Filters::Test
  include Haml::Filters::Base

  def render(text)
    "TESTING HAHAHAHA!"
  end
end

module Hamlit::RailsHelpers
  def test_partial(name, locals = {})
    Hamlit::Template.new { File.read(File.join(TemplateTest::TEMPLATE_PATH, "_#{name}.haml")) }.render(self, locals)
  end
end

class Egocentic
  def method_missing(*args)
    self
  end
end

class DummyController
  attr_accessor :logger
  def initialize
    @logger = Egocentic.new
  end

  def self.controller_path
    ''
  end

  def controller_path
    ''
  end
end

class TemplateTest < Haml::TestCase
  TEMPLATE_PATH = File.join(File.dirname(__FILE__), "templates")
  TEMPLATES = [
    'very_basic',
    #'standard',
    #'helpers',
    #'whitespace_handling',
    'original_engine',
    'list',
    'helpful',
    'silent_script',
    'tag_parsing',
    #'just_stuff',
    #'partials',
    #'nuke_outer_whitespace',
    #'nuke_inner_whitespace',
    #'render_layout',
    #'partial_layout',
    'partial_layout_erb',
  ]

  def setup
    @base = create_base

    # filters template uses :sass
    # Sass::Plugin.options.update(:line_comments => true, :style => :compact)
  end

  def create_base
    vars = { 'article' => Article.new, 'foo' => 'value one' }

    context = ActionView::LookupContext.new(TEMPLATE_PATH)
    base = ActionView::Base.new(context, vars, ActionController::Base.new)

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
    options = options.merge(:format => :xhtml)
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

    silence_warnings do
      load_result(name).split("\n").zip(render_method[name].split("\n")).each_with_index do |pair, line|
        message = "template: #{name}\nline:     #{line}"
        assert_equal(pair.first, pair.last, message)
      end
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

  def test_templates
    skip
    TEMPLATES
  end

  def test_render_method_returning_null_with_ugly; skip
    @base.instance_eval do
      def empty
        nil
      end
      def render_something(&block)
        capture(self, &block)
      end
    end

    content_to_render = "%h1 This is part of the broken view.\n= render_something do |thing|\n  = thing.empty do\n    = 'test'"
    result = render(content_to_render, :ugly => true)
    expected_result = "<h1>This is part of the broken view.</h1>\n"
    assert_equal(expected_result, result)
  end

  def test_simple_rendering_with_ugly
    skip
    assert_haml_ugly("%p test\n= capture { 'foo' }")
  end

  def test_templates_should_render_correctly_with_render_proc; skip
    assert_renders_correctly("standard") do |name|
      engine = Hamlit::HamlEngine.new(File.read(File.dirname(__FILE__) + "/templates/#{name}.haml"), :format => :xhtml)
      engine.render_proc(@base).call
    end
  end

  def test_templates_should_render_correctly_with_def_method; skip
    assert_renders_correctly("standard") do |name|
      engine = Haml::HamlEngine.new(File.read(File.dirname(__FILE__) + "/templates/#{name}.haml"), :format => :xhtml)
      engine.def_method(@base, "render_standard")
      @base.render_standard
    end
  end

  def test_instance_variables_should_work_inside_templates
    @base.instance_variable_set(:@content_for_layout, 'something')
    assert_haml_ugly("%p= @content_for_layout", scope: @base)

    @base.instance_eval("@author = 'Hampton Catlin'")
    assert_haml_ugly(".author= @author", scope: @base)

    @base.instance_eval("@author = 'Hampton'")
    assert_haml_ugly("= @author", scope: @base)

    @base.instance_eval("@author = 'Catlin'")
    assert_haml_ugly("= @author", scope: @base)
  end

  def test_instance_variables_should_work_inside_attributes
    skip
    @base.instance_eval("@author = 'hcatlin'")
    assert_haml_ugly("%p{:class => @author} foo")
  end

  def test_template_renders_should_eval
    assert_equal("2\n", render("= 1+1"))
  end

  def test_haml_options; skip
    old_options = Haml::Template.options.dup
    Haml::Template.options[:suppress_eval] = true
    old_base, @base = @base, create_base
    assert_renders_correctly("eval_suppressed")
  ensure
    skip
    @base = old_base
    Haml::Template.options = old_options
  end

  def test_with_output_buffer_with_ugly; skip
    assert_equal(<<HTML, render(<<HAML, :ugly => true))
<p>
foo
baz
</p>
HTML
%p
  foo
  -# Parenthesis required due to Rails 3.0 deprecation of block helpers
  -# that return strings.
  - (with_output_buffer do
    bar
    = "foo".gsub(/./) do |s|
      - "flup"
  - end)
  baz
HAML
  end

  def test_exceptions_should_work_correctly; skip
    begin
      render("- raise 'oops!'")
    rescue Exception => e
      assert_equal("oops!", e.message)
      assert_match(/^\(haml\):1/, e.backtrace[0])
    else
      assert false
    end

    template = <<END
%p
  %h1 Hello!
  = "lots of lines"
  = "even more!"
  - raise 'oh no!'
  %p
    this is after the exception
    %strong yes it is!
ho ho ho.
END

    begin
      render(template.chomp)
    rescue Exception => e
      assert_match(/^\(haml\):5/, e.backtrace[0])
    else
      assert false
    end
  end

  def test_form_builder_label_with_block; skip
    output = render(<<HAML, :action_view)
= form_for @article, :as => :article, :html => {:class => nil, :id => nil}, :url => '' do |f|
  = f.label :title do
    Block content
HAML
    fragment = Nokogiri::HTML.fragment output
    assert_equal "Block content", fragment.css('form label').first.content.strip
  end

  ## XSS Protection Tests

  def test_escape_html_option_set; skip
    assert Haml::Template.options[:escape_html]
  end

  def test_xss_protection; skip
    assert_equal("Foo &amp; Bar\n", render('= "Foo & Bar"', :action_view))
  end

  def test_xss_protection_with_safe_strings; skip
    assert_equal("Foo & Bar\n", render('= Haml::Util.html_safe("Foo & Bar")', :action_view))
  end

  def test_xss_protection_with_bang; skip
    assert_haml_ugly('!= "Foo & Bar"', :action_view)
  end

  def test_xss_protection_in_interpolation; skip
    assert_equal("Foo &amp; Bar\n", render('Foo #{"&"} Bar', :action_view))
  end

  def test_xss_protection_in_attributes; skip
    assert_equal("<div data-html='&lt;foo&gt;bar&lt;/foo&gt;'></div>\n", render('%div{ "data-html" => "<foo>bar</foo>" }', :action_view))
  end

  def test_xss_protection_in_attributes_with_safe_strings; skip
    assert_equal("<div data-html='<foo>bar</foo>'></div>\n", render('%div{ "data-html" => "<foo>bar</foo>".html_safe }', :action_view))
  end

  def test_xss_protection_with_bang_in_interpolation; skip
    assert_haml_ugly('! Foo #{"&"} Bar', :action_view)
  end

  def test_xss_protection_with_safe_strings_in_interpolation; skip
    assert_equal("Foo & Bar\n", render('Foo #{Haml::Util.html_safe("&")} Bar', :action_view))
  end

  def test_xss_protection_with_mixed_strings_in_interpolation; skip
    assert_equal("Foo & Bar &amp; Baz\n", render('Foo #{Haml::Util.html_safe("&")} Bar #{"&"} Baz', :action_view))
  end

  def test_rendered_string_is_html_safe; skip
    assert(render("Foo").html_safe?)
  end

  def test_rendered_string_is_html_safe_with_action_view
    assert(render("Foo", :action_view).html_safe?)
  end

  def test_xss_html_escaping_with_non_strings
    assert_haml_ugly("= html_escape(4)")
  end

  def test_xss_protection_with_concat; skip
    assert_equal("Foo &amp; Bar", render('- concat "Foo & Bar"', :action_view))
  end

  def test_xss_protection_with_concat_with_safe_string; skip
    assert_equal("Foo & Bar", render('- concat(Haml::Util.html_safe("Foo & Bar"))', :action_view))
  end

  def test_xss_protection_with_safe_concat; skip
    assert_equal("Foo & Bar", render('- safe_concat "Foo & Bar"', :action_view))
  end

  ## Regression

  def test_xss_protection_with_nested_haml_tag; skip
    assert_equal(<<HTML, render(<<HAML, :action_view))
<div>
  <ul>
    <li>Content!</li>
  </ul>
</div>
HTML
- haml_tag :div do
  - haml_tag :ul do
    - haml_tag :li, "Content!"
HAML
  end

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

  def test_cache; skip
    @base.controller = ActionController::Base.new
    @base.controller.perform_caching = false
    assert_equal(<<HTML, render(<<HAML, :action_view))
Test
HTML
- cache do
  Test
HAML
  end
end
