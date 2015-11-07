describe Hamlit::Engine do
  include RenderAssertion

  it { assert_haml(%q|%div|) }
  it { assert_inline(%Q|.bar.foo|) }
  it { assert_inline(%Q|.foo.bar|) }
  it { assert_inline(%Q|%div(class='bar foo')|) }
  it { assert_inline(%Q|%div(class='foo bar')|) }
  it { assert_inline(%Q|%div{ class: 'bar foo' }|) }
  # it { assert_inline(%q|%a{ href: "'\"" }|) }
  it { assert_inline(%Q|%a{ href: '/search?foo=bar&hoge=<fuga>' }|) }

  specify 'class attributes' do
    assert_haml(<<-HAML)
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

    assert_haml('.a{ class: [] }')
  end

  specify 'common attributes' do
    assert_haml(<<-HAML)
      - new = 'new'
      - old = 'old'
      %span(foo='new'){ foo: 'old' }
      %span{ foo: 'old' }(foo='new')
      %span(foo=new){ foo: 'old' }
      %span{ foo: 'old' }(foo=new)
      %span(foo=new){ foo: old }
      %span{ foo: old }(foo=new)
    HAML
  end
end
