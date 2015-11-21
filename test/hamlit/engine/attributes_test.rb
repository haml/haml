describe Hamlit::Engine do
  include RenderHelper

  describe 'id attributes' do
    specify 'compatilibity' do
      assert_haml(<<-HAML.unindent)
        #a
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
        #d#c{ id: %w[b e] }(id=id)
        - hash = { id: 'a' }
        %div{ hash }
        #b{ hash }
        #b{ hash }(id='c')
        - id = 'c'
        #b{ hash }(id=id)
      HAML
    end

    specify 'incompatibility' do
      assert_render(%Q|<div id='a'></div>\n|, %q|#a{ id: [] }|)
      assert_render(%Q|<a id=''></a>\n|, %q|%a{ id: [nil, false] }|)
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <div id='c_a'></div>
      HTML
        - id = 'a'
        #d#c{ id: [] }(id=id)
      HAML
    end
  end

  describe 'class attributes' do
    specify 'compatibility' do
      assert_haml(%q|.bar.foo|)
      assert_haml(%q|.foo.bar|)
      assert_haml(%Q|%div(class='bar foo')|)
      assert_haml(%Q|%div(class='foo bar')|)
      assert_haml(%Q|%div{ class: 'bar foo' }|)
      assert_haml(<<-HAML.unindent)
        - klass = 'b a'
        .b.a
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

    specify 'incompatibility' do
      assert_render(%Q|<div class='a b'></div>\n|, %q|%div{ class: 'b a' }|)
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <div class='a b'></div>
      HTML
        - klass = 'b a'
        %div{ class: klass }
      HAML
    end
  end

  specify 'data attributes' do
    assert_haml(<<-HAML.unindent)
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
      %a{ data: { nil => 3 } }
      %a{ data: 3 }
    HAML
  end

  specify 'boolean attributes' do
    assert_haml(<<-HAML.unindent)
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

    assert_haml(%q|%input(checked=true)|)
    assert_haml(%q|%input(checked=true)|, format: :xhtml)
  end

  describe 'common attributes' do
    specify 'compatibility' do
      assert_haml(%Q|%a{ href: '/search?foo=bar&hoge=<fuga>' }|)
      assert_haml(<<-HAML.unindent)
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

    specify 'incompatibility' do
      assert_render(%Q|<a href='&#39;&quot;'></a>\n|, %q|%a{ href: "'\"" }|)
    end
  end

  specify 'object reference' do
    ::TestObject = Struct.new(:id) unless defined?(::TestObject)
    assert_render(%Q|<a class='test_object' id='test_object_10'></a>\n|, <<-HAML.unindent)
      - foo = TestObject.new(10)
      %a[foo]
    HAML
    assert_render(%Q|<a class='test_object' id='test_object_10'></a>\n|, <<-HAML.unindent)
      - foo = TestObject.new(10)
      %a[foo, nil]
    HAML
    assert_render(%Q|<a class='test_object' id='test_object_new'></a>\n|, <<-HAML.unindent)
      - foo = TestObject.new(nil)
      %a[foo]
    HAML
    assert_render(%Q|<a class='pre_test_object' id='pre_test_object_10'></a>\n|, <<-HAML.unindent)
      - foo = TestObject.new(10)
      %a[foo, 'pre']
    HAML
    assert_render(%Q|<div class='static test_object' id='static_test_object_10'></div>\n|, %q|.static#static[TestObject.new(10)]|)
    assert_render(%Q|<a class='dynamic pre_test_object static' id='static_dynamic_pre_test_object_10'></a>\n|, <<-HAML.unindent)
      - foo = TestObject.new(10)
      - dynamic = 'dynamic'
      %a.static#static[foo, 'pre']{ id: dynamic, class: dynamic }
    HAML
    assert_render(%Q|<div class='static' id='static'></div>\n|, %q|.static#static[nil]|)
  end

  describe 'engine options' do
    specify 'attr_quote' do
      assert_render(%Q|<a href='/'></a>\n|, %q|%a{ href: '/' }|)
      assert_render(%Q|<a href='/'></a>\n|, %q|%a{ href: '/' }|, attr_quote: ?')
      assert_render(%Q|<a href=*/*></a>\n|, %q|%a{ href: '/' }|, attr_quote: ?*)

      assert_render(%Q|<a id="/"></a>\n|, %q|%a{ id: '/' }|, attr_quote: ?")
      assert_render(%Q|<a id="/"></a>\n|, %Q|- val = '/'\n%a{ id: val }|, attr_quote: ?")
      assert_render(%Q|<a id="/"></a>\n|, %Q|- hash = { id: '/' }\n%a{ hash }|, attr_quote: ?")

      assert_render(%Q|<a class="/"></a>\n|, %q|%a{ class: '/' }|, attr_quote: ?")
      assert_render(%Q|<a class="/"></a>\n|, %Q|- val = '/'\n%a{ class: val }|, attr_quote: ?")
      assert_render(%Q|<a class="/"></a>\n|, %Q|- hash = { class: '/' }\n%a{ hash }|, attr_quote: ?")

      assert_render(%Q|<a data="/"></a>\n|, %q|%a{ data: '/' }|, attr_quote: ?")
      assert_render(%Q|<a data-url="/"></a>\n|, %q|%a{ data: { url: '/' } }|, attr_quote: ?")
      assert_render(%Q|<a data="/"></a>\n|, %Q|- val = '/'\n%a{ data: val }|, attr_quote: ?")
      assert_render(%Q|<a data-url="/"></a>\n|, %Q|- val = { url: '/' }\n%a{ data: val }|, attr_quote: ?")
      assert_render(%Q|<a data-url="/"></a>\n|, %Q|- hash = { data: { url: '/' } }\n%a{ hash }|, attr_quote: ?")

      assert_render(%Q|<a disabled="/"></a>\n|, %q|%a{ disabled: '/' }|, attr_quote: ?")
      assert_render(%Q|<a disabled="/"></a>\n|, %Q|- val = '/'\n%a{ disabled: val }|, attr_quote: ?")
      assert_render(%Q|<a disabled="/"></a>\n|, %Q|- hash = { disabled: '/' }\n%a{ hash }|, attr_quote: ?")
      assert_render(%Q|<a disabled="disabled"></a>\n|, %Q|- hash = { disabled: true }\n%a{ hash }|, attr_quote: ?", format: :xhtml)

      assert_render(%Q|<a href="/"></a>\n|, %q|%a{ href: '/' }|, attr_quote: ?")
      assert_render(%Q|<a href="/"></a>\n|, %Q|- val = '/'\n%a{ href: val }|, attr_quote: ?")
      assert_render(%Q|<a href="/"></a>\n|, %Q|- hash = { href: '/' }\n%a{ hash }|, attr_quote: ?")
    end

    specify 'escape_attrs' do
      assert_render(%Q|<a id='&<>"/'></a>\n|, %q|%a{ id: '&<>"/' }|, escape_attrs: false)
      assert_render(%Q|<a id='&amp;&lt;&gt;&quot;/'></a>\n|, %q|%a{ id: '&<>"/' }|, escape_attrs: true)
      assert_render(%Q|<a id='&<>"/'></a>\n|, %Q|- val = '&<>"/'\n%a{ id: val }|, escape_attrs: false)
      assert_render(%Q|<a id='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|- val = '&<>"/'\n%a{ id: val }|, escape_attrs: true)
      assert_render(%Q|<a id='&<>"/'></a>\n|, %Q|- hash = { id: '&<>"/' }\n%a{ hash }|, escape_attrs: false)
      assert_render(%Q|<a id='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|- hash = { id: '&<>"/' }\n%a{ hash }|, escape_attrs: true)

      assert_render(%Q|<a id='&<>"/'></a>\n|, %q|%a{ id: '&<>"/' }|, escape_attrs: false)
      assert_render(%Q|<a id='&amp;&lt;&gt;&quot;/'></a>\n|, %q|%a{ id: '&<>"/' }|, escape_attrs: true)
      assert_render(%Q|<a id='&<>"/'></a>\n|, %Q|- val = '&<>"/'\n%a{ id: val }|, escape_attrs: false)
      assert_render(%Q|<a id='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|- val = '&<>"/'\n%a{ id: val }|, escape_attrs: true)
      assert_render(%Q|<a id='&<>"/'></a>\n|, %Q|- hash = { id: '&<>"/' }\n%a{ hash }|, escape_attrs: false)
      assert_render(%Q|<a id='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|- hash = { id: '&<>"/' }\n%a{ hash }|, escape_attrs: true)

      assert_render(%Q|<a data='&<>"/'></a>\n|, %q|%a{ data: '&<>"/' }|, escape_attrs: false)
      assert_render(%Q|<a data='&amp;&lt;&gt;&quot;/'></a>\n|, %q|%a{ data: '&<>"/' }|, escape_attrs: true)
      assert_render(%Q|<a data='&<>"/'></a>\n|, %Q|- val = '&<>"/'\n%a{ data: val }|, escape_attrs: false)
      assert_render(%Q|<a data='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|- val = '&<>"/'\n%a{ data: val }|, escape_attrs: true)
      assert_render(%Q|<a data='&<>"/'></a>\n|, %Q|- hash = { data: '&<>"/' }\n%a{ hash }|, escape_attrs: false)
      assert_render(%Q|<a data='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|- hash = { data: '&<>"/' }\n%a{ hash }|, escape_attrs: true)

      assert_render(%Q|<a disabled='&<>"/'></a>\n|, %q|%a{ disabled: '&<>"/' }|, escape_attrs: false)
      assert_render(%Q|<a disabled='&amp;&lt;&gt;&quot;/'></a>\n|, %q|%a{ disabled: '&<>"/' }|, escape_attrs: true)
      assert_render(%Q|<a disabled='&<>"/'></a>\n|, %Q|- val = '&<>"/'\n%a{ disabled: val }|, escape_attrs: false)
      assert_render(%Q|<a disabled='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|- val = '&<>"/'\n%a{ disabled: val }|, escape_attrs: true)
      assert_render(%Q|<a disabled='&<>"/'></a>\n|, %Q|- hash = { disabled: '&<>"/' }\n%a{ hash }|, escape_attrs: false)
      assert_render(%Q|<a disabled='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|- hash = { disabled: '&<>"/' }\n%a{ hash }|, escape_attrs: true)

      assert_render(%Q|<a href='&<>"/'></a>\n|, %q|%a{ href: '&<>"/' }|, escape_attrs: false)
      assert_render(%Q|<a href='&amp;&lt;&gt;&quot;/'></a>\n|, %q|%a{ href: '&<>"/' }|, escape_attrs: true)
      assert_render(%Q|<a href='&<>"/'></a>\n|, %Q|- val = '&<>"/'\n%a{ href: val }|, escape_attrs: false)
      assert_render(%Q|<a href='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|- val = '&<>"/'\n%a{ href: val }|, escape_attrs: true)
      assert_render(%Q|<a href='&<>"/'></a>\n|, %Q|- hash = { href: '&<>"/' }\n%a{ hash }|, escape_attrs: false)
      assert_render(%Q|<a href='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|- hash = { href: '&<>"/' }\n%a{ hash }|, escape_attrs: true)
    end

    specify 'format' do
      assert_render(%Q|<a disabled></a>\n|, %q|%a{ disabled: true }|, format: :html)
      assert_render(%Q|<a disabled='disabled'></a>\n|, %q|%a{ disabled: true }|, format: :xhtml)
      assert_render(%Q|<a disabled></a>\n|, %Q|- val = true\n%a{ disabled: val }|, format: :html)
      assert_render(%Q|<a disabled='disabled'></a>\n|, %Q|- val = true\n%a{ disabled: val }|, format: :xhtml)
      assert_render(%Q|<a disabled></a>\n|, %Q|- hash = { disabled: true }\n%a{ hash }|, format: :html)
      assert_render(%Q|<a disabled='disabled'></a>\n|, %Q|- hash = { disabled: true }\n%a{ hash }|, format: :xhtml)
    end
  end
end
