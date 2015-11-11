describe Hamlit::Engine do
  include RenderAssertion

  it { assert_haml(%q|%div|) }
  it { assert_inline(%Q|.bar.foo|) }
  it { assert_inline(%Q|.foo.bar|) }
  it { assert_inline(%Q|%div(class='bar foo')|) }
  it { assert_inline(%Q|%div(class='foo bar')|) }
  it { assert_inline(%Q|%div{ class: 'bar foo' }|) }
  it { assert_render(%q|%a{ href: "'\"" }|, %Q|<a href='&#39;&quot;'></a>\n|) }
  it { assert_inline(%Q|%a{ href: '/search?foo=bar&hoge=<fuga>' }|) }

  specify do
    assert_haml(<<-HAML)
      - hash = { class: nil }
      .b{ hash, class: 'a' }
    HAML
  end

  specify 'id attributes' do
    assert_haml(<<-HAML)
      #a
      #a{ id: [] }
      #a{ id: nil }
      #a{ id: nil }(id=nil)
      #a{ id: false }
      #a{ id: 'b' }
      #b{ id: 'a' }
      - id = 'c'
      #a{ id: 'b' }(id=id)
      - id = 'b'
      #c{ id: a = 'a' }(id=id)
      - id = 'a'
      #d#c{ id: a = 'b' }(id=id)
      #d#c{ id: [] }(id=id)
      #d#c{ id: %w[b e] }(id=id)
      - hash = { id: 'a' }
      %div{ hash }
      #b{ hash }
      #b{ hash }(id='c')
      - id = 'c'
      #b{ hash }(id=id)
    HAML
  end

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
      .a{ class: [] }
      .a{ class: %w[c b] }
      %div{ class: 'b a' }(class=klass)
      %div(class=klass){ class: 'b a' }
      .a.d(class=klass){ class: 'c d' }
      .a.d(class=klass)
      .a.c(class='b')
      - klass = nil
      .a{:class => nil}
      .a{:class => false}
      .a{:class => klass}
      .a{:class => nil}(class=klass)
      - hash = { class: nil }
      .b{ hash, class: 'a' }
      .b{ hash, 'class' => 'a' }
      - hash = { class: 'd' }
      .a{ hash }
      .b{ hash, class: 'a' }(class='c')
      .b{ hash, class: 'a' }(class=klass)
    HAML
  end

  specify 'data attributes' do
    assert_haml(<<-HAML)
      - val = false
      #foo.bar{ data: { disabled: val } }
      - hash = {:a => {:b => 'c'}}
      - hash[:d] = hash
      %div{:data => hash}
      - hash = { data: hash }
      %div{ hash }
      %div{:data => {:foo_bar => 'blip', :baz => 'bang'}}
      %div{ data: { raw_src: 'foo' } }
      %a{ data: { value: [count: 1] } }
      %a{ 'data-disabled' => true }
      %a{ :'data-disabled' => true }
    HAML
  end

  specify 'boolean attributes' do
    assert_haml(<<-HAML)
      %input{ disabled: nil }
      %input{ disabled: false }
      %input{ disabled: true }
      %input{ disabled: 'false' }
      %input{ disabled: val = nil }
      %input{ disabled: val = false }
      %input{ disabled: val = true }
      %input{ disabled: val = 'false' }
      %input{ disabled: nil }(disabled=true)
      %input{ disabled: false }(disabled=true)
      %input{ disabled: true }(disabled=false)
      - hash = { disabled: false }
      %a{ hash }
      - hash = { disabled: nil }
      %a{ hash }
      %input(disabled=true){ disabled: nil }
      %input(disabled=true){ disabled: false }
      %input(disabled=false){ disabled: true }
      - val = true
      %input(disabled=val){ disabled: false }
      - val = false
      %input(disabled=val)
      %input(disabled=nil)
      %input(disabled=false)
      %input(disabled=true)
      %input(disabled='false')
      - val = 'false'
      %input(disabled=val)
      %input(disabled='false'){ disabled: true }
      %input(disabled='false'){ disabled: false }
      %input(disabled='false'){ disabled: nil }
      %input(disabled=''){ disabled: nil }
    HAML
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
