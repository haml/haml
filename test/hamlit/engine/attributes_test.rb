describe Hamlit::Engine do
  include RenderAssertion

  it { assert_inline(%Q[%div], %Q[<div></div>]) }
  it { assert_inline(%Q[.bar.foo], %Q[<div class='bar foo'></div>]) }
  it { assert_inline(%Q[.foo.bar], %Q[<div class='foo bar'></div>]) }
  it { assert_inline(%Q[%div(class='bar foo')], %Q[<div class='bar foo'></div>]) }
  it { assert_inline(%Q[%div(class='foo bar')], %Q[<div class='foo bar'></div>]) }
  it { assert_inline(%Q[%div{ class: 'bar foo' }], %Q[<div class='bar foo'></div>]) }
  it { assert_inline(%q[%a{ href: "'\"" }], %Q[<a href='&#39;&quot;'></a>]) }
  it { assert_inline(%Q[%a{ href: '/search?foo=bar&hoge=<fuga>' }], %Q[<a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>]) }

  specify do
    assert_render(<<-HAML, <<-HTML)
      - new = 'new'
      - old = 'old'
      %span(foo='new'){ foo: 'old' }
      %span{ foo: 'old' }(foo='new')
      %span(foo=new){ foo: 'old' }
      %span{ foo: 'old' }(foo=new)
      %span(foo=new){ foo: old }
      %span{ foo: old }(foo=new)
    HAML
      <span foo='old'></span>
      <span foo='old'></span>
      <span foo='old'></span>
      <span foo='old'></span>
      <span foo='old'></span>
      <span foo='old'></span>
    HTML
  end
end
