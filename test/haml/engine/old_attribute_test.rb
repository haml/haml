# frozen_string_literal: true

require_relative '../../test_helper'

describe Haml::Engine do
  include RenderHelper

  describe 'old attributes' do
    it 'renders attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span class="foo">bar</span>
      HTML
        %span{class: 'foo'} bar
      HAML
    end

    it 'renders attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span data="2">bar</span>
      HTML
        %span{ data: 2 } bar
      HAML
    end

    it 'renders attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span class="foo">bar</span>
      HTML
        %span{ :class => 'foo' } bar
      HAML
    end

    it 'renders attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span class="foo" id="bar">bar</span>
      HTML
        %span{ :class => 'foo', id: 'bar' } bar
      HAML
    end

    it 'renders attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span data-disabled>bar</span>
      HTML
        %span{ :'data-disabled' => true } bar
      HAML
    end

    it 'renders value-less attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="foo" data-doo="yep" data-yabba="dabba"></div>
      HTML
        - data = { yabba: 'dabba', doo: 'yep' }
        .foo{ data: }
      HAML
    end if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1')

    it 'accepts method call including comma' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <body class="bb" data-confirm="really?" data-disabled id="a"></body>
      HTML
        %body{ class: "#{"ab".gsub(/a/, 'b')}", data: { confirm: 'really?', disabled: true }, id: 'c'.gsub(/c/, 'a') }
      HAML
    end

    it 'accepts tag content' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span class="foo"><b>bar</b></span>
      HTML
        %span{ class: 'foo' } <b>bar</b>
      HAML
    end

    it 'renders multi-byte chars as static attribute value' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <img alt="こんにちは">
      HTML
        %img{ alt: 'こんにちは' }
      HAML
    end

    it 'sorts static attributes by name' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span foo="bar" hoge="piyo"></span>
        <span foo="bar" hoge="piyo"></span>
      HTML
        %span{ :foo => "bar", :hoge => "piyo"}
        %span{ :hoge => "piyo", :foo => "bar"}
      HAML
    end

    it 'renders %() string attributes' do
      assert_render(<<-'HTML'.unindent, <<-'HAML'.unindent)
        <p title="foo(a)"></p>
      HTML
        - some_local_variable = 'a'
        %p{ title: %(foo(#{some_local_variable})) }
      HAML
    end

    describe 'runtime attributes' do
      it 'renders runtime hash attribute' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span foo="bar"></span>
        HTML
          - hash = { foo: 'bar' }
          %span{ hash }
        HAML
      end

      it 'renders multiples hashes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span a="b" c="d" e="f"></span>
        HTML
          - h1 = { a: 'b' }
          - h2 = { c: 'd' }
          - h3 = { e: 'f' }
          %span{ h1, h2, h3 }
        HAML
      end

      it 'renders multiples hashes and literal hash' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span a="b" c="d" e="f" g="h" i="j"></span>
        HTML
          - h1 = { a: 'b' }
          - h2 = { c: 'd' }
          - h3 = { e: 'f' }
          %span{ h1, h2, h3, g: 'h', i: 'j' }
        HAML
      end

      it 'does not crash when nil is given' do
        if /java/ === RUBY_PLATFORM
          skip 'maybe due to Ripper of JRuby'
        end

        assert_raises ArgumentError do
          render_haml("%div{ nil }")
        end
      end
    end

    describe 'joinable attributes' do
      it 'joins class with a space' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <p class="a b c"></p>
          <p class="a b c"></p>
          <p class="a b c"></p>
        HTML
          - val = ['a', 'b', 'c']
          %p{ class: val }
          %p{ class: %w[a b c] }
          %p{ class: ['a', 'b', 'c'] }
        HAML
      end

      it 'joins attribute class and element class' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class="foo bar"></div>
          <div class="foo bar"></div>
          <div class="foo bar"></div>
          <div class="foo bar baz"></div>
        HTML
          .foo{ class: ['bar'] }
          .foo{ class: ['bar', 'foo'] }
          .foo{ class: ['bar', nil] }
          .foo{ class: ['bar', 'baz'] }
        HAML
      end

      it 'joins id with an underscore' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <p id="a_b_c"></p>
          <p id="a_b_c"></p>
          <p id="a_b_c"></p>
        HTML
          - val = ['a', 'b', 'c']
          %p{ id: val }
          %p{ id: %w[a b c] }
          %p{ id: ['a', 'b', 'c'] }
        HAML
      end

      it 'does not join others' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <a data-value="[#{render_hash({ count: 1 })}]"></a>
        HTML
          %a{ data: { value: [count: 1] } }
        HAML
      end
    end

    describe 'deletable attributes' do
      def with_custom_attributes(*attributes, &block)
        begin
          old_attributes = Haml::BOOLEAN_ATTRIBUTES.dup
          Haml::BOOLEAN_ATTRIBUTES.push(*attributes)
          block.call
        ensure
          Haml::BOOLEAN_ATTRIBUTES.replace(old_attributes)
        end
      end

      it 'deletes attributes whose value is nil or false' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <input>
          <input>
          <input>
          <input>
          <input>
        HTML
          - hash = { checked: false }
          %input{ hash }
          %input{ checked: false }
          %input{ checked: nil }
          - checked = nil
          %input{ checked: checked }
          - checked = false
          %input{ checked: checked }
        HAML
      end

      it 'deletes some limited attributes with dynamic value' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class="bar" id="foo"></div>
          <div class="bar" id="foo"></div>
          <div class="bar" id="foo"></div>
          <div class="bar" id="foo"></div>
          <div class="bar" id="foo"></div>
          <div class="bar" id="foo"></div>
          <div class="bar" id="foo"></div>
          <div class="bar" id="foo"></div>
        HTML
          - val = false
          #foo.bar{ autofocus: val }
          #foo.bar{ checked: val }
          #foo.bar{ data: { disabled: val } }
          #foo.bar{ disabled: val }
          #foo.bar{ formnovalidate: val }
          #foo.bar{ multiple: val }
          #foo.bar{ readonly: val }
          #foo.bar{ required: val }
        HAML
      end

      it 'does not delete non-boolean attributes, for optimization' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <a href="false"></a>
          <a href="false"></a>
          <a href="false"></a>
          <a></a>
          <a></a>
          <a></a>
          <a href=""></a>
          <a href=""></a>
          <a href=""></a>
          <a></a>
          <a></a>
          <a></a>
        HTML
          %a{ href: false }
          - val = false
          %a{ href: val }
          - hash = { href: false }
          %a{ hash }

          %a{ disabled: false }
          - val = false
          %a{ disabled: val }
          - hash = { disabled: false }
          %a{ hash }

          %a{ href: nil }
          - val = nil
          %a{ href: val }
          - hash = { href: nil }
          %a{ hash }

          %a{ disabled: nil }
          - val = nil
          %a{ disabled: val }
          - hash = { disabled: nil }
          %a{ hash }
        HAML
      end

      it 'deletes custom attributes in BOOLEAN_ATTRIBUTES' do
        with_custom_attributes('custom') do
          assert_render(<<-HTML.unindent, <<-HAML.unindent)
            <div></div>
            <div></div>
            <div></div>
            <div></div>
            <div></div>
          HTML
            %div(custom=false)
            - custom = false
            %div(custom=custom)
            %div{ custom: false }
            %div{ custom: custom }
            - hash = { custom: custom }
            %div{ hash }
          HAML
        end
      end

      it 'deletes data- attributes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div></div>
          <div></div>
          <div></div>
        HTML
          %div{ "data-foo" => false }
          - foo = false
          %div{ "data-foo" => foo }
          - hash = { "data-foo" => foo }
          %div{ hash }
        HAML
      end

      it 'deletes aria- attributes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div></div>
          <div></div>
          <div></div>
        HTML
          %div{ "aria-foo" => false }
          - foo = false
          %div{ "aria-foo" => foo }
          - hash = { "aria-foo" => foo }
          %div{ hash }
        HAML
      end
    end

    describe 'html escape' do
      it 'escapes attribute values on static attributes' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <a title="&#39;"></a>
          <a title="&#39;&quot;"></a>
          <a href="/search?foo=bar&amp;hoge=&lt;fuga&gt;"></a>
        HTML
          %a{title: "'"}
          %a{title: "'\""}
          %a{href: '/search?foo=bar&hoge=<fuga>'}
        HAML
      end

      it 'escapes attribute values on dynamic attributes' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <a title="&#39;&quot;"></a>
          <a href="/search?foo=bar&amp;hoge=&lt;fuga&gt;"></a>
        HTML
          - title = "'\""
          - href  = '/search?foo=bar&hoge=<fuga>'
          %a{title: title}
          %a{href: href}
        HAML
      end

      it 'escapes attribute values on hash attributes' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <a title="&#39;&quot;"></a>
          <a href="/search?foo=bar&amp;hoge=&lt;fuga&gt;"></a>
        HTML
          - title = { title: "'\"" }
          - href  = { href:  '/search?foo=bar&hoge=<fuga>' }
          %a{ title }
          %a{ href }
        HAML
      end
    end

    describe 'nested data attributes' do
      it 'renders data attribute by hash' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span class="foo" data-bar="baz"></span>
        HTML
          - hash = { bar: 'baz' }
          %span.foo{ data: hash }
        HAML
      end

      it 'renders true attributes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span data-disabled>bar</span>
        HTML
          %span{ data: { disabled: true } } bar
        HAML
      end

      it 'renders nested hash whose value is variable' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span data-disabled>bar</span>
        HTML
          - hash = { disabled: true }
          %span{ data: hash } bar
        HAML
      end

      it 'changes an underscore in a nested key to a hyphen' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div data-raw-src="foo"></div>
        HTML
          %div{ data: { raw_src: 'foo' } }
        HAML
      end

      it 'changes an underscore in a nested dynamic attribute' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div data-raw-src="foo"></div>
        HTML
          - hash = { raw_src: 'foo' }
          %div{ data: hash }
        HAML
      end
    end

    describe 'nested aria attributes' do
      it 'renders aria attribute by hash' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span aria-bar="baz" class="foo"></span>
        HTML
          - hash = { bar: 'baz' }
          %span.foo{ aria: hash }
        HAML
      end

      it 'renders true attributes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span aria-disabled>bar</span>
        HTML
          %span{ aria: { disabled: true } } bar
        HAML
      end

      it 'renders nested hash whose value is variable' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span aria-disabled>bar</span>
        HTML
          - hash = { disabled: true }
          %span{ aria: hash } bar
        HAML
      end

      it 'changes an underscore in a nested key to a hyphen' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div aria-raw-src="foo"></div>
        HTML
          %div{ aria: { raw_src: 'foo' } }
        HAML
      end

      it 'changes an underscore in a nested dynamic attribute' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div aria-raw-src="foo"></div>
        HTML
          - hash = { raw_src: 'foo' }
          %div{ aria: hash }
        HAML
      end

      it 'renders hash-only dynamic attributes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div aria-label="foo"></div>
        HTML
          - hash = { aria: { label: 'foo' } }
          %div{ hash }
        HAML
      end
    end

    describe 'element class with attribute class' do
      it 'does not generate double classes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class="item first"></div>
        HTML
          .item{ class: 'first' }
        HAML
      end

      it 'does not generate double classes for a variable' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class="element val"></div>
        HTML
          - val = 'val'
          .element{ class: val }
        HAML
      end

      it 'does not generate double classes for hash attributes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class="element val"></div>
        HTML
          - hash = { class: 'val' }
          .element{ hash }
        HAML
      end
    end

    describe 'element id with attribute id' do
      it 'does not generate double ids' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div id="item_first"></div>
        HTML
          #item{ id: 'first' }
        HAML
      end

      it 'does not generate double ids for a variable' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div id="item_first"></div>
        HTML
          - val = 'first'
          #item{ id: val }
        HAML
      end

      it 'does not generate double ids for hash attributes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div id="item_first"></div>
        HTML
          - hash = { id: 'first' }
          #item{ hash }
        HAML
      end

      it 'does not generate double ids and classes for hash attributes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class="bar foo" id="item_first"></div>
        HTML
          - hash = { id: 'first', class: 'foo' }
          #item.bar{ hash }
        HAML
      end
    end

    if RUBY_VERSION >= "2.2.0"
      describe 'Ruby 2.2 syntax' do
        it 'renders static attributes' do
          assert_render(<<-HTML.unindent, <<-HAML.unindent)
            <meta content="IE=edge" http-equiv="X-UA-Compatible">
          HTML
            %meta{ content: 'IE=edge', 'http-equiv': 'X-UA-Compatible' }
          HAML
        end

        it 'renders dynamic attributes' do
          assert_render(<<-HTML.unindent, <<-HAML.unindent)
            <meta content="IE=edge" http-equiv="X-UA-Compatible">
          HTML
            - hash = { content: 'IE=edge' }
            %meta{ hash, 'http-equiv': 'X-UA-Compatible' }
          HAML
        end
      end
    end
  end
end
