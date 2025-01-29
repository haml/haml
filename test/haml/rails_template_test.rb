# frozen_string_literal: true

# Explicitly requiring rails_template because rails initializers is not executed here.
require 'haml/rails_template'

describe Haml::RailsTemplate do
  def render(haml)
    ActionView::Template.register_template_handler(:haml, Haml::RailsTemplate.new)
    base = Class.new(ActionView::Base) do
      def compiled_method_container
        self.class
      end
    end.new(ActionView::LookupContext.new(''), {}, ActionController::Base.new)
    base.render(inline: haml, type: :haml)
  end

  specify 'html escape' do
    assert_equal %Q|&lt;script&gt;alert(&quot;a&quot;);&lt;/script&gt;\n|, render(<<-HAML.unindent)
      = '<script>alert("a");</script>'
    HAML
    assert_equal %Q|<script>alert("a");</script>\n|, render(<<-HAML.unindent)
      = '<script>alert("a");</script>'.html_safe
    HAML
    skip 'escape is not working well in truffleruby' if RUBY_ENGINE == 'truffleruby'
    assert_equal %Q|&lt;script&gt;alert(&quot;a&quot;);&lt;/script&gt;\n|, render(<<-'HAML'.unindent)
      #{'<script>alert("a");</script>'}
    HAML
    assert_equal %Q|<script>alert("a");</script>\n|, render(<<-'HAML'.unindent)
      #{'<script>alert("a");</script>'.html_safe}
    HAML
  end

  specify 'attribute escape' do
    assert_equal %Q|<a href='&lt;script&gt;alert(&quot;a&quot;);&lt;/script&gt;'></a>\n|, render(<<-HAML.unindent)
      %a{ href: '<script>alert("a");</script>' }
    HAML
    assert_equal %Q|<a href='&lt;script&gt;'></a>\n|, render(<<-HAML.unindent)
      %a{ href: '<script>'.html_safe }
    HAML
  end

  it 'forces to escape html_safe attributes' do
    assert_equal <<-'HTML'.unindent, render(<<-HAML.unindent)
      <meta content='&#39;&quot;'>
      <meta content='&#39;&quot;'>
      <meta content='&#39;&quot;'>
    HTML
      %meta{ content: %{'"}.html_safe }
      - val = %{'"}.html_safe
      %meta{ content: val }
      - hash = { content: val }
      %meta{ hash }
    HAML
  end

  specify 'boolean attributes' do
    assert_equal %Q|<span checked='no' disabled></span>\n|, render(<<-HAML.unindent)
      - val = 'no'
      %span{ disabled: true, checked: val, autoplay: false }
    HAML
  end

  specify 'link_to' do
    assert_equal %Q|<a class="bar" href="#">foo</a>\n|, render(%q|= link_to 'foo', '#', class: 'bar'|)
  end

  specify 'content_tag' do
    assert_equal <<-HTML.unindent.strip, render(<<-HAML.unindent)
      <div>text
      </div>
    HTML
      = content_tag :div do
        text
    HAML
    assert_equal <<-HTML.unindent.strip, render(<<-HAML.unindent)
      <div>text
      </div><div>text
      </div><div>text
      </div>
    HTML
      - 3.times do
        = content_tag :div do
          text
    HAML
  end

  specify 'find_and_preserve' do
    assert_equal <<-HTML.unindent, render(<<-'HAML'.unindent)
      Foo bar
      &lt;pre&gt;foo bar&lt;/pre&gt;
      &lt;pre&gt;foo&amp;#x000A;bar&lt;/pre&gt;
    HTML
      = find_and_preserve("Foo bar")
      = find_and_preserve("<pre>foo bar</pre>")
      = find_and_preserve("<pre>foo\nbar</pre>")
    HAML
  end

  specify 'capture_haml' do
    assert_equal <<-HTML.unindent, render(<<-'HAML'.unindent)
      <div class='capture'><span>
      <p>Capture</p>
      </span>
      </div>
    HTML
      - html = capture_haml do
        %span
          %p Capture

      .capture= html
    HAML
  end

  specify 'preserve' do
    assert_equal %q|Foo&#x000A;Bar|, render(<<-'HAML'.unindent)
      = preserve do
        Foo
        Bar
    HAML
    assert_equal %q|<div />|, render(<<-'HAML'.unindent)
      = preserve do
        <div />
    HAML
  end

  specify 'succeed' do
    assert_equal %Q|<i>succeed</i>&amp;\n|, render(<<-'HAML'.unindent)
      = succeed '&' do
        %i succeed
    HAML
  end

  specify 'precede' do
    assert_equal %Q|&amp;<i>precede</i>\n|, render(<<-'HAML'.unindent)
      = precede '&' do
        %i precede
    HAML
  end

  specify 'surround' do
    assert_equal %Q|&amp;<i>surround</i>&amp;\n|, render(<<-'HAML'.unindent)
      = surround '&' do
        %i surround
    HAML
  end

  specify 'object which returns SafeBuffer for to_s (like kaminari)' do
    class ::TosUnsafeObject; def to_s; "<hr>"; end; end
    class ::TosSafeObject; def to_s; "<hr>".html_safe; end; end

    assert_equal %Q|<hr>\n|, render(%q|= ::TosSafeObject.new|)
    assert_equal %Q|&lt;hr&gt;\n|, render(%q|= ::TosUnsafeObject.new|)
    assert_equal %Q|<p><hr></p>\n|, render(%Q|%p= ::TosSafeObject.new|)
    assert_equal %Q|<p>\n<hr>\n</p>\n|, render(%Q|%p\n  = ::TosSafeObject.new|)
  end

  specify 'encoding' do
    assert_equal Encoding.default_external, render('Test').encoding
  end

  specify '.set_options' do
    original = Haml::RailsTemplate.options[:use_html_safe]
    begin
      Haml::RailsTemplate.set_options(use_html_safe: !original)
      assert_equal !original, Haml::RailsTemplate.options[:use_html_safe]
    ensure
      Haml::RailsTemplate.set_options(use_html_safe: original)
    end
  end
end
