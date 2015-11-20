# Explicitly requiring rails_template because rails initializers is not executed here.
require 'hamlit/rails_template'

describe Hamlit::RailsTemplate do
  def render(haml)
    ActionView::Template.register_template_handler(:haml, Hamlit::RailsTemplate.new)
    base = ActionView::Base.new(__dir__, {})
    base.render(inline: haml, type: :haml)
  end

  specify 'html escape' do
    assert_equal %Q|&lt;script&gt;alert(&quot;a&quot;);&lt;/script&gt;\n|, render(<<-HAML.unindent)
      = '<script>alert("a");</script>'
    HAML
    assert_equal %Q|<script>alert("a");</script>\n|, render(<<-HAML.unindent)
      = '<script>alert("a");</script>'.html_safe
    HAML
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
    assert_equal %q|Foo&amp;#x000A;Bar|, render(<<-'HAML'.unindent)
      = preserve do
        Foo
        Bar
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
  end
end
