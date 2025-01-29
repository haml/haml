# frozen_string_literal: true

require_relative '../../test_helper'

describe Haml::Engine do
  include RenderHelper

  describe 'id attributes' do
    describe 'compatilibity' do
      # TODO: assert_haml tests nothing since migration to haml repository. Use assert_render instead.
      it { assert_haml(%q|#a|) }
      it { assert_haml(%q|#a{ id: nil }|) }
      it { assert_haml(%q|#a{ id: nil }(id=nil)|) }
      it { assert_haml(%q|#a{ id: false }|) }
      it { assert_haml(%q|#a{ id: 'b' }|) }
      it { assert_haml(%q|#b{ id: 'a' }|) }
      it { assert_haml(%q|%a{ 'id' => 60 }|) }
      if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.4.0')
        it { assert_haml(%q|%p{class: "a #{["1", "2", "3"].join}"} foo|) }
      end

      it { assert_haml(%q|#a{ id: 'b' }(id=id)|,       locals: { id: 'c' }) }
      it { assert_haml(%q|#c{ id: a = 'a' }(id=id)|,   locals: { id: 'b' }) }
      it { assert_haml(%q|#d#c{ id: a = 'b' }(id=id)|, locals: { id: 'a' }) }
      it { assert_haml(%q|#d#c{ id: %w[b e] }(id=id)|, locals: { id: 'a' }) }

      it { assert_haml(%q|%div{ hash }|,       locals: { hash: { id: 'a' } }) }
      it { assert_haml(%q|#b{ hash }|,         locals: { hash: { id: 'a' } }) }
      it { assert_haml(%q|#b{ hash }(id='c')|, locals: { hash: { id: 'a' }, id: 'c' }) }
      it { assert_haml(%q|#b{ hash }(id=id)|,  locals: { hash: { id: 'a' }, id: 'c' }) }

      it { assert_haml(<<-HAML.unindent) }
        .haml#info{
          "data": {
            "content": "/:|}",
            "haml-info": {
              "url": "https://haml.info",
            }
          }
        } Haml
      HAML
    end

    describe 'incompatibility' do
      # TODO: assert_haml tests nothing since migration to haml repository. Use assert_render instead.
      it { assert_render(%Q|<div id='a'></div>\n|,   %q|#a{ id: [] }|) }
      it { assert_render(%Q|<div id=''></div>\n|,    %q|%div{ id: [nil, false] }|) }
      it { assert_render(%Q|<div id='c_a'></div>\n|, %q|#d#c{ id: [] }(id=id)|, locals: { id: 'a' }) }
      it { assert_render(%Q|<div id=''></div>\n|,    %q|%div{ id: nil }|) }
      it { assert_render(%Q|<input id=''>\n|,        %q|%input{ id: false }|) }
      it { assert_render(%Q|<input id=''>\n|,        %q|%input{ id: val }|, locals: { val: false }) }
      it { assert_render(%Q|<input id=''>\n|,        %q|%input{ hash }|, locals: { hash: { id: false } }) }
    end
  end

  describe 'class attributes' do
    describe 'compatibility' do
      # TODO: assert_haml tests nothing since migration to haml repository. Use assert_render instead.
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
      it { assert_haml(%q|%a{ 'class' => 60 }|) }

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

      it { assert_haml(%q|%div{ class: 'b a' }|) }
      it { assert_haml(%q|%div{ class: klass }|, locals: { klass: 'b a' }) }
      it { assert_haml(%q|%div(class='b a')|) }
      it { assert_haml(%q|%div(class=klass)|, locals: { klass: 'b a' }) }

      it { assert_haml(%q|%div{ class: [false, 'a', nil] }|) }
      it { assert_haml(%q|%div{ class: %q[b a] }|) }
      it { assert_haml(%q|%div{ class: %q[b a b] }|) }

      it { assert_haml(%q|%span.c2{class: ["c1", "c3", :c2]}|) }
      it { assert_haml(%q|%span{class: [1, nil, false, true]}|) }
      it do
        assert_haml(<<-HAML.unindent)
          - v = [1, nil, false, true]
          %span{class: v}
        HAML
      end
      it do
        assert_haml(<<-HAML.unindent)
          - h1 = {class: 'c1', id: ['id1', 'id3']}
          - h2 = {class: [{}, 'c2'], id: 'id2'}
          %span#main.content{h1, h2} hello
        HAML
      end
    end

    describe 'incompatibility' do
      it { assert_render(%Q|<div class=''></div>\n|, %q|%div{ class: nil }|) }
      it { assert_render(%Q|<div class=''></div>\n|, %q|%div{ class: false }|) }
      it { assert_render(%Q|<div class=''></div>\n|, %q|%div{ class: false }|) }
      it { assert_render(%Q|<div class=''></div>\n|, %q|%div{ class: val }|, locals: { val: false }) }
      it { assert_render(%Q|<div class=''></div>\n|, %q|%div{ hash }|, locals: { hash: { class: false } }) }
    end
  end

  describe 'data attributes' do
    # TODO: assert_haml tests nothing since migration to haml repository. Use assert_render instead.
    it { assert_haml(%q|#foo.bar{ data: { disabled: val } }|, locals: { val: false }) }
    it { skip; assert_haml(%q|%div{:data => hash}|, locals: { hash: { :a => { :b => 'c' } }.tap { |h| h[:d] = h } }) }
    it { skip; assert_haml(%q|%div{ hash }|, locals: { hash: { data: { :a => { :b => 'c' } }.tap { |h| h[:d] = h } } }) }
    it { assert_haml(%q|%div{:data => {:foo_bar => 'blip', :baz => 'bang'}}|) }
    it { assert_haml(%q|%div{ data: { raw_src: 'foo' } }|) }
    it { assert_haml(%q|%a{ data: { value: [count: 1] } }|) }
    it { assert_haml(%q|%a{ 'data-disabled' => true }|) }
    it { assert_haml(%q|%a{ :'data-disabled' => true }|) }
    it { assert_haml(%q|%a{ data: { nil => 3 } }|) }
    it { assert_haml(%q|%a{ data: 3 }|) }
    it { assert_haml(%q|%a(data=3)|) }
    it { assert_haml(%q|%a{ 'data-bar' => 60 }|) }

    it { assert_haml(%q|%a{ data: { overlay_modal: 'foo' } }|) }
    it { assert_haml(%q|%a{ data: { overlay_modal: true } }|) }
    it { assert_haml(%q|%a{ data: { overlay_modal: false } }|) }

    it { assert_haml(%q|%a{ data: true }|) }
    it { assert_haml(%q|%a{ data: { nil => true } }|) }
    it { assert_haml(%q|%a{ data: { false => true } }|) }

    it { skip; assert_haml(%q|%a{ { data: { 'foo-bar' => 1 } }, data: { foo: { bar: 2 } } }|) }
    it { assert_haml(%q|%a{ { data: { foo: { bar: 2 } } }, data: { 'foo-bar' => 2 } }|) }
    it { assert_haml(%q|%a{ { data: { :'foo-bar' => 1 } }, data: { 'foo-bar' => 2 } }|) }

    it do
      assert_haml(<<-HAML.unindent)
        - old = { disabled: true,  checked: false, href: false, 'hello-world' => '<>/' }
        - new = { disabled: false, checked: true,  href: '<>/', hello: {}, 'hello_hoge' => true, foo: { 'bar&baz' => 'hoge' } }
        - hash = { data: { href: true, hash: true } }
        %a(data=new){ hash, data: old }
      HAML
    end
    it do
      assert_haml(<<-HAML.unindent)
        - h1 = { data: 'should be overwritten' }
        - h2 = { data: nil }
        %div{ h1, h2 }
      HAML
    end
  end

  describe 'boolean attributes' do
    # TODO: assert_haml tests nothing since migration to haml repository. Use assert_render instead.
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

    it { assert_haml(%q|%input{ 'data-overlay_modal' => nil }|) }
    it { assert_haml(%q|%input{ 'data-overlay_modal' => false }|) }
    it { assert_haml(%q|%input{ 'data-overlay_modal' => true }|) }
    it { assert_haml(%q|%input{ 'data-overlay_modal' => 'false' }|) }

    it { assert_haml(%q|%input{ :'data-overlay_modal' => val = nil }|) }
    it { assert_haml(%q|%input{ :'data-overlay_modal' => val = false }|) }
    it { assert_haml(%q|%input{ :'data-overlay_modal' => val = true }|) }
    it { assert_haml(%q|%input{ :'data-overlay_modal' => val = 'false' }|) }

    it { assert_haml(%q|%a{ hash }|, locals: { hash: { 'data-overlay_modal' => false } }) }
    it { assert_haml(%q|%a{ hash }|, locals: { hash: { 'data-overlay_modal' => true } }) }

    it { assert_haml(%q|%a{ 'disabled' => 60 }|) }
  end

  describe 'common attributes' do
    describe 'compatibility' do
      # TODO: assert_haml tests nothing since migration to haml repository. Use assert_render instead.
      it { assert_haml(%Q|%a{ href: '/search?foo=bar&hoge=<fuga>' }|) }
      it { assert_haml(%Q|- h = {foo: 1, 'foo' => 2}\n%span{ h }|) }
      it { assert_haml(%q|%span(foo='new'){ foo: 'old' }|, locals: { new: 'new', old: 'old' }) }
      it { assert_haml(%q|%span(foo=new){ foo: 'old' }|,   locals: { new: 'new', old: 'old' }) }
      it { assert_haml(%q|%span(foo=new){ foo: old }|,     locals: { new: 'new', old: 'old' }) }
      it { assert_haml(%q|%span{ foo: 'old' }(foo='new')|, locals: { new: 'new', old: 'old' }) }
      it { assert_haml(%q|%span{ foo: 'old' }(foo=new)|,   locals: { new: 'new', old: 'old' }) }
      it { assert_haml(%q|%span{ foo: old }(foo=new)|,     locals: { new: 'new', old: 'old' }) }
      it do
        assert_haml(<<-HAML.unindent)
          - h1 = { foo: 1 }
          - h2 = { foo: 2 }
          %div{ h1, h2 }
        HAML
      end
      it do
        assert_haml(<<-'HAML'.unindent)
          - h = { "class\0with null" => 'is not class' }
          %div{ h }
        HAML
      end
      it { assert_haml(%q|%a{ 'href' => 60 }|) }
    end

    describe 'incompatibility' do
      it { assert_render(%Q|<a href='&#39;&quot;'></a>\n|, %q|%a{ href: "'\"" }|) }
      it { assert_render(%Q|<input value=''>\n|,      %q|%input{ value: nil }|) }
      it { assert_render(%Q|<input value='false'>\n|, %q|%input{ value: false }|) }
      it { assert_render(%Q|<input value='false'>\n|, %q|%input{ value: val }|, locals: { val: false }) }
      it { assert_render(%Q|<input value='false'>\n|, %q|%input{ hash }|, locals: { hash: { value: false } }) }
      it do
        assert_render(%Q|<div foo=''></div>\n|, <<-HAML.unindent)
          - h1 = { foo: 'should be overwritten' }
          - h2 = { foo: nil }
          %div{ h1, h2 }
        HAML
      end
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
        %Q|<a class='static dynamic pre_test_object' id='static_dynamic_pre_test_object_10'></a>\n|,
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
