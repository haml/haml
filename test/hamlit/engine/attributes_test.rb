describe Hamlit::Engine do
  include RenderHelper

  describe 'id attributes' do
    describe 'compatilibity' do
      it { assert_haml(%q|#a|) }
      it { assert_haml(%q|#a{ id: nil }|) }
      it { assert_haml(%q|#a{ id: nil }(id=nil)|) }
      it { assert_haml(%q|#a{ id: false }|) }
      it { assert_haml(%q|#a{ id: 'b' }|) }
      it { assert_haml(%q|#b{ id: 'a' }|) }

      it { assert_haml(%q|#a{ id: 'b' }(id=id)|,       locals: { id: 'c' }) }
      it { assert_haml(%q|#c{ id: a = 'a' }(id=id)|,   locals: { id: 'b' }) }
      it { assert_haml(%q|#d#c{ id: a = 'b' }(id=id)|, locals: { id: 'a' }) }
      it { assert_haml(%q|#d#c{ id: %w[b e] }(id=id)|, locals: { id: 'a' }) }

      it { assert_haml(%q|%div{ hash }|,       locals: { hash: { id: 'a' } }) }
      it { assert_haml(%q|#b{ hash }|,         locals: { hash: { id: 'a' } }) }
      it { assert_haml(%q|#b{ hash }(id='c')|, locals: { hash: { id: 'a' }, id: 'c' }) }
      it { assert_haml(%q|#b{ hash }(id=id)|,  locals: { hash: { id: 'a' }, id: 'c' }) }
    end

    describe 'incompatibility' do
      it { assert_render(%Q|<div id='a'></div>\n|,   %q|#a{ id: [] }|) }
      it { assert_render(%Q|<a id=''></a>\n|,        %q|%a{ id: [nil, false] }|) }
      it { assert_render(%Q|<div id='c_a'></div>\n|, %q|#d#c{ id: [] }(id=id)|, locals: { id: 'a' }) }
    end
  end

  describe 'class attributes' do
    describe 'compatibility' do
      it { assert_haml(%q|.bar.foo|) }
      it { assert_haml(%q|.foo.bar|) }
      it { assert_haml(%q|%div(class='bar foo')|) }
      it { assert_haml(%q|%div(class='foo bar')|) }
      it { assert_haml(%q|%div{ class: 'bar foo' }|) }

      it { assert_haml(%q|.b{ class: 'a' }|) }
      it { assert_haml(%q|.a{ class: 'b a' }|) }
      it { assert_haml(%q|.b.a{ class: 'b a' }|) }
      it { assert_haml(%q|.b{ class: 'b a' }|) }

      it { assert_haml(%q|.a{ class: klass }|,   locals: { klass: 'b a' }) }
      it { assert_haml(%q|.b{ class: klass }|,   locals: { klass: 'b a' }) }
      it { assert_haml(%q|.b.a{ class: klass }|, locals: { klass: 'b a' }) }

      it { assert_haml(%q|.b{ class: 'c a' }|) }
      it { assert_haml(%q|.b{ class: 'a c' }|) }
      it { assert_haml(%q|.a{ class: [] }|) }
      it { assert_haml(%q|.a{ class: %w[c b] }|) }
      it { assert_haml(%q|.a.c(class='b')|) }

      it { assert_haml(%q|%div{ class: 'b a' }(class=klass)|, locals: { klass: 'b a' }) }
      it { assert_haml(%q|%div(class=klass){ class: 'b a' }|, locals: { klass: 'b a' }) }
      it { assert_haml(%q|.a.d(class=klass){ class: 'c d' }|, locals: { klass: 'b a' }) }
      it { assert_haml(%q|.a.d(class=klass)|,                 locals: { klass: 'b a' }) }

      it { assert_haml(%q|.a{:class => klass}|,               locals: { klass: nil }) }
      it { assert_haml(%q|.a{:class => nil}(class=klass)|,    locals: { klass: nil }) }
      it { assert_haml(%q|.a{:class => nil}|) }
      it { assert_haml(%q|.a{:class => false}|) }

      it { assert_haml(%q|.b{ hash, class: 'a' }|,     locals: { hash: { class: nil } }) }
      it { assert_haml(%q|.b{ hash, :class => 'a' }|,  locals: { hash: { class: nil } }) }
      it { assert_haml(%q|.b{ hash, 'class' => 'a' }|, locals: { hash: { class: nil } }) }

      it { assert_haml(%q|.a{ hash }|,                          locals: { hash: { class: 'd' } }) }
      it { assert_haml(%q|.b{ hash, class: 'a' }(class='c')|,   locals: { hash: { class: 'd' } }) }
      it { assert_haml(%q|.b{ hash, class: 'a' }(class=klass)|, locals: { hash: { class: 'd' }, klass: nil }) }
    end

    describe 'incompatibility' do
      it { assert_render(%Q|<div class=''></div>\n|, %q|%div{ class: nil }|) }
      it { assert_render(%Q|<div class='a b'></div>\n|, %q|%div{ class: 'b a' }|) }
      it { assert_render(%Q|<div class='a b'></div>\n|, %q|%div{ class: klass }|, locals: { klass: 'b a' }) }
    end
  end

  describe 'data attributes' do
    it { assert_haml(%q|#foo.bar{ data: { disabled: val } }|, locals: { val: false }) }
    it { assert_haml(%q|%div{:data => hash}|, locals: { hash: { :a => { :b => 'c' } }.tap { |h| h[:d] = h } }) }
    it { assert_haml(%q|%div{ hash }|, locals: { hash: { data: { :a => { :b => 'c' } }.tap { |h| h[:d] = h } } }) }
    it { assert_haml(%q|%div{:data => {:foo_bar => 'blip', :baz => 'bang'}}|) }
    it { assert_haml(%q|%div{ data: { raw_src: 'foo' } }|) }
    it { assert_haml(%q|%a{ data: { value: [count: 1] } }|) }
    it { assert_haml(%q|%a{ 'data-disabled' => true }|) }
    it { assert_haml(%q|%a{ :'data-disabled' => true }|) }
    it { assert_haml(%q|%a{ data: { nil => 3 } }|) }
    it { assert_haml(%q|%a{ data: 3 }|) }
  end

  describe 'boolean attributes' do
    it { assert_haml(%q|%input{ disabled: nil }|) }
    it { assert_haml(%q|%input{ disabled: false }|) }
    it { assert_haml(%q|%input{ disabled: true }|) }
    it { assert_haml(%q|%input{ disabled: 'false' }|) }

    it { assert_haml(%q|%input{ disabled: val = nil }|) }
    it { assert_haml(%q|%input{ disabled: val = false }|) }
    it { assert_haml(%q|%input{ disabled: val = true }|) }
    it { assert_haml(%q|%input{ disabled: val = 'false' }|) }

    it { assert_haml(%q|%input{ disabled: nil }(disabled=true)|) }
    it { assert_haml(%q|%input{ disabled: false }(disabled=true)|) }
    it { assert_haml(%q|%input{ disabled: true }(disabled=false)|) }
    it { assert_haml(%q|%a{ hash }|, locals: { hash: { disabled: false } }) }
    it { assert_haml(%q|%a{ hash }|, locals: { hash: { disabled: nil } }) }

    it { assert_haml(%q|input(disabled=true){ disabled: nil }|) }
    it { assert_haml(%q|input(disabled=true){ disabled: false }|) }
    it { assert_haml(%q|input(disabled=false){ disabled: true }|) }
    it { assert_haml(%q|%input(disabled=val){ disabled: false }|, locals: { val: true }) }
    it { assert_haml(%q|%input(disabled=val){ disabled: false }|, locals: { val: false }) }

    it { assert_haml(%q|%input(disabled=nil)|) }
    it { assert_haml(%q|%input(disabled=false)|) }
    it { assert_haml(%q|%input(disabled=true)|) }
    it { assert_haml(%q|%input(disabled='false')|) }
    it { assert_haml(%q|%input(disabled=val)|, locals: { val: 'false' }) }

    it { assert_haml(%q|%input(disabled='false'){ disabled: true }|) }
    it { assert_haml(%q|%input(disabled='false'){ disabled: false }|) }
    it { assert_haml(%q|%input(disabled='false'){ disabled: nil }|) }
    it { assert_haml(%q|%input(disabled=''){ disabled: nil }|) }

    it { assert_haml(%q|%input(checked=true)|) }
    it { assert_haml(%q|%input(checked=true)|, format: :xhtml) }
  end

  describe 'common attributes' do
    describe 'compatibility' do
      it { assert_haml(%Q|%a{ href: '/search?foo=bar&hoge=<fuga>' }|) }
      it { assert_haml(%q|%span(foo='new'){ foo: 'old' }|, locals: { new: 'new', old: 'old' }) }
      it { assert_haml(%q|%span(foo=new){ foo: 'old' }|,   locals: { new: 'new', old: 'old' }) }
      it { assert_haml(%q|%span(foo=new){ foo: old }|,     locals: { new: 'new', old: 'old' }) }
      it { assert_haml(%q|%span{ foo: 'old' }(foo='new')|, locals: { new: 'new', old: 'old' }) }
      it { assert_haml(%q|%span{ foo: 'old' }(foo=new)|,   locals: { new: 'new', old: 'old' }) }
      it { assert_haml(%q|%span{ foo: old }(foo=new)|,     locals: { new: 'new', old: 'old' }) }
    end

    describe 'incompatibility' do
      it { assert_render(%Q|<a href='&#39;&quot;'></a>\n|, %q|%a{ href: "'\"" }|) }
    end
  end

  describe 'object reference' do
    ::TestObject = Struct.new(:id) unless defined?(::TestObject)

    it { assert_render(%Q|<a class='test_object' id='test_object_10'></a>\n|, %q|%a[foo]|,      locals: { foo: TestObject.new(10) }) }
    it { assert_render(%Q|<a class='test_object' id='test_object_10'></a>\n|, %q|%a[foo, nil]|, locals: { foo: TestObject.new(10) }) }
    it { assert_render(%Q|<a class='test_object' id='test_object_new'></a>\n|, %q|%a[foo]|,     locals: { foo: TestObject.new(nil) }) }
    it { assert_render(%Q|<a class='pre_test_object' id='pre_test_object_10'></a>\n|, %q|%a[foo, 'pre']|, locals: { foo: TestObject.new(10) }) }
    it { assert_render(%Q|<div class='static test_object' id='static_test_object_10'></div>\n|, %q|.static#static[TestObject.new(10)]|) }
    it { assert_render(%Q|<div class='static' id='static'></div>\n|, %q|.static#static[nil]|) }
    it do
      assert_render(
        %Q|<a class='dynamic pre_test_object static' id='static_dynamic_pre_test_object_10'></a>\n|,
        %q|%a.static#static[foo, 'pre']{ id: dynamic, class: dynamic }|,
        locals: { foo: TestObject.new(10), dynamic: 'dynamic' },
      )
    end
  end

  describe 'engine options' do
    describe 'attr_quote' do
      it { assert_render(%Q|<a href='/'></a>\n|, %q|%a{ href: '/' }|) }
      it { assert_render(%Q|<a href='/'></a>\n|, %q|%a{ href: '/' }|, attr_quote: ?') }
      it { assert_render(%Q|<a href=*/*></a>\n|, %q|%a{ href: '/' }|, attr_quote: ?*) }

      it { assert_render(%Q|<a id="/"></a>\n|, %q|%a{ id: '/' }|, attr_quote: ?") }
      it { assert_render(%Q|<a id="/"></a>\n|, %q|%a{ id: val }|, attr_quote: ?", locals: { val: '/' }) }
      it { assert_render(%Q|<a id="/"></a>\n|, %q|%a{ hash }|,    attr_quote: ?", locals: { hash: { id: '/' } }) }

      it { assert_render(%Q|<a class="/"></a>\n|, %q|%a{ class: '/' }|, attr_quote: ?") }
      it { assert_render(%Q|<a class="/"></a>\n|, %q|%a{ class: val }|, attr_quote: ?", locals: { val: '/' }) }
      it { assert_render(%Q|<a class="/"></a>\n|, %q|%a{ hash }|,       attr_quote: ?", locals: { hash: { class: '/' } }) }

      it { assert_render(%Q|<a data="/"></a>\n|,     %q|%a{ data: '/' }|,          attr_quote: ?") }
      it { assert_render(%Q|<a data="/"></a>\n|,     %q|%a{ data: val }|,          attr_quote: ?", locals: { val: '/' }) }
      it { assert_render(%Q|<a data-url="/"></a>\n|, %q|%a{ data: { url: '/' } }|, attr_quote: ?") }
      it { assert_render(%Q|<a data-url="/"></a>\n|, %q|%a{ data: val }|,          attr_quote: ?", locals: { val: { url: '/' } }) }
      it { assert_render(%Q|<a data-url="/"></a>\n|, %q|%a{ hash }|,               attr_quote: ?", locals: { hash: { data: { url: '/' } } }) }

      it { assert_render(%Q|<a disabled="/"></a>\n|,        %q|%a{ disabled: '/' }|, attr_quote: ?") }
      it { assert_render(%Q|<a disabled="/"></a>\n|,        %Q|%a{ disabled: val }|, attr_quote: ?", locals: { val: '/' }) }
      it { assert_render(%Q|<a disabled="/"></a>\n|,        %Q|%a{ hash }|,          attr_quote: ?", locals: { hash: { disabled: '/' } }) }
      it { assert_render(%Q|<a disabled="disabled"></a>\n|, %Q|%a{ hash }|,          attr_quote: ?", format: :xhtml, locals: { hash: { disabled: true } }) }

      it { assert_render(%Q|<a href="/"></a>\n|, %q|%a{ href: '/' }|, attr_quote: ?") }
      it { assert_render(%Q|<a href="/"></a>\n|, %q|%a{ href: val }|, attr_quote: ?", locals: { val: '/' }) }
      it { assert_render(%Q|<a href="/"></a>\n|, %q|%a{ hash }|,      attr_quote: ?", locals: { hash: { href: '/' } }) }
    end

    describe 'escape_attrs' do
      it { assert_render(%Q|<a id='&<>"/'></a>\n|,                %q|%a{ id: '&<>"/' }|, escape_attrs: false) }
      it { assert_render(%Q|<a id='&<>"/'></a>\n|,                %Q|%a{ id: val }|,     escape_attrs: false, locals: { val: '&<>"/' }) }
      it { assert_render(%Q|<a id='&<>"/'></a>\n|,                %Q|%a{ hash }|,        escape_attrs: false, locals: { hash: { id: '&<>"/' } }) }
      it { assert_render(%Q|<a id='&amp;&lt;&gt;&quot;/'></a>\n|, %q|%a{ id: '&<>"/' }|, escape_attrs: true) }
      it { assert_render(%Q|<a id='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|%a{ id: val }|,     escape_attrs: true, locals: { val: '&<>"/' }) }
      it { assert_render(%Q|<a id='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|%a{ hash }|,        escape_attrs: true, locals: { hash: { id: '&<>"/' } }) }

      it { assert_render(%Q|<a class='&<>"/'></a>\n|,                %q|%a{ class: '&<>"/' }|, escape_attrs: false) }
      it { assert_render(%Q|<a class='&<>"/'></a>\n|,                %Q|%a{ class: val }|,     escape_attrs: false, locals: { val: '&<>"/' }) }
      it { assert_render(%Q|<a class='&<>"/'></a>\n|,                %Q|%a{ hash }|,           escape_attrs: false, locals: { hash: { class: '&<>"/' } }) }
      it { assert_render(%Q|<a class='&amp;&lt;&gt;&quot;/'></a>\n|, %q|%a{ class: '&<>"/' }|, escape_attrs: true) }
      it { assert_render(%Q|<a class='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|%a{ class: val }|,     escape_attrs: true, locals: { val: '&<>"/' }) }
      it { assert_render(%Q|<a class='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|%a{ hash }|,           escape_attrs: true, locals: { hash: { class: '&<>"/' } }) }

      it { assert_render(%Q|<a data='&<>"/'></a>\n|,                %q|%a{ data: '&<>"/' }|, escape_attrs: false) }
      it { assert_render(%Q|<a data='&<>"/'></a>\n|,                %Q|%a{ data: val }|,     escape_attrs: false, locals: { val: '&<>"/' }) }
      it { assert_render(%Q|<a data='&<>"/'></a>\n|,                %Q|%a{ hash }|,          escape_attrs: false, locals: { hash: { data: '&<>"/' } }) }
      it { assert_render(%Q|<a data='&amp;&lt;&gt;&quot;/'></a>\n|, %q|%a{ data: '&<>"/' }|, escape_attrs: true) }
      it { assert_render(%Q|<a data='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|%a{ data: val }|,     escape_attrs: true, locals: { val: '&<>"/' }) }
      it { assert_render(%Q|<a data='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|%a{ hash }|,          escape_attrs: true, locals: { hash: { data: '&<>"/' } }) }

      it { assert_render(%Q|<a disabled='&<>"/'></a>\n|,                %q|%a{ disabled: '&<>"/' }|, escape_attrs: false) }
      it { assert_render(%Q|<a disabled='&<>"/'></a>\n|,                %Q|%a{ disabled: val }|,     escape_attrs: false, locals: { val: '&<>"/' }) }
      it { assert_render(%Q|<a disabled='&<>"/'></a>\n|,                %Q|%a{ hash }|,              escape_attrs: false, locals: { hash: { disabled: '&<>"/' } }) }
      it { assert_render(%Q|<a disabled='&amp;&lt;&gt;&quot;/'></a>\n|, %q|%a{ disabled: '&<>"/' }|, escape_attrs: true) }
      it { assert_render(%Q|<a disabled='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|%a{ disabled: val }|,     escape_attrs: true, locals: { val: '&<>"/' }) }
      it { assert_render(%Q|<a disabled='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|%a{ hash }|,              escape_attrs: true, locals: { hash: { disabled: '&<>"/' } }) }

      it { assert_render(%Q|<a href='&<>"/'></a>\n|,                %q|%a{ href: '&<>"/' }|, escape_attrs: false) }
      it { assert_render(%Q|<a href='&<>"/'></a>\n|,                %Q|%a{ href: val }|,     escape_attrs: false, locals: { val: '&<>"/' }) }
      it { assert_render(%Q|<a href='&<>"/'></a>\n|,                %Q|%a{ hash }|,          escape_attrs: false, locals: { hash: { href: '&<>"/' } }) }
      it { assert_render(%Q|<a href='&amp;&lt;&gt;&quot;/'></a>\n|, %q|%a{ href: '&<>"/' }|, escape_attrs: true) }
      it { assert_render(%Q|<a href='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|%a{ href: val }|,     escape_attrs: true, locals: { val: '&<>"/' }) }
      it { assert_render(%Q|<a href='&amp;&lt;&gt;&quot;/'></a>\n|, %Q|%a{ hash }|,          escape_attrs: true, locals: { hash: { href: '&<>"/' } }) }
    end

    describe 'format' do
      it { assert_render(%Q|<a disabled></a>\n|,            %q|%a{ disabled: true }|, format: :html) }
      it { assert_render(%Q|<a disabled></a>\n|,            %q|%a{ disabled: val }|,  format: :html, locals: { val: true }) }
      it { assert_render(%Q|<a disabled></a>\n|,            %q|%a{ hash }|,           format: :html, locals: { hash: { disabled: true } }) }
      it { assert_render(%Q|<a disabled='disabled'></a>\n|, %q|%a{ disabled: true }|, format: :xhtml) }
      it { assert_render(%Q|<a disabled='disabled'></a>\n|, %q|%a{ disabled: val }|,  format: :xhtml, locals: { val: true }) }
      it { assert_render(%Q|<a disabled='disabled'></a>\n|, %q|%a{ hash }|,           format: :xhtml, locals: { hash: { disabled: true } }) }
    end
  end
end
