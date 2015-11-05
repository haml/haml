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

  specify 'class attributes' do
    assert_render(<<-HAML, <<-HTML)
      - klass = 'b a'
      .b.a
      %div{ class: 'b a' }
      %div{ class: klass }
      .b{ class: 'a' }
      .a{ class: 'b a' }
      .b.a{ class: 'b a' }
      .b{ class: 'b a' }
      .a{ class: klass }
      .b{ class: klass }
      .b.a{ class: klass }
      .b{ class: 'c a' }
      .b{ class: 'a c' }
    HAML
      <div class='b a'></div>
      <div class='b a'></div>
      <div class='b a'></div>
      <div class='a b'></div>
      <div class='a b'></div>
      <div class='a b'></div>
      <div class='a b'></div>
      <div class='a b'></div>
      <div class='a b'></div>
      <div class='a b'></div>
      <div class='a b c'></div>
      <div class='a b c'></div>
    HTML
  end

  specify 'common attributes' do
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
