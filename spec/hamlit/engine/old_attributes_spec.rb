describe Hamlit::Engine do
  describe 'old attributes' do
    it 'renders attributes' do
      assert_render(<<-HAML, <<-HTML)
        %span{class: 'foo'} bar
      HAML
        <span class='foo'>bar</span>
      HTML
    end

    it 'renders attributes' do
      assert_render(<<-HAML, <<-HTML)
        %span{ data: 2 } bar
      HAML
        <span data='2'>bar</span>
      HTML
    end

    it 'renders attributes' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ :class => 'foo' } bar
      HAML
        <span class='foo'>bar</span>
      HTML
    end

    it 'renders attributes' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ :class => 'foo', id: 'bar' } bar
      HAML
        <span class='foo' id='bar'>bar</span>
      HTML
    end

    it 'renders attributes' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ :'data-disable' => true } bar
      HAML
        <span data-disable>bar</span>
      HTML
    end

    it 'accepts even illegal input for haml' do
      assert_render(<<-'HAML', <<-HTML, error_with: [:haml, :faml])
        %span{ class: '}}}', id: '{}}' } }{
      HAML
        <span class='}}}' id='{}}'>}{</span>
      HTML
    end

    it 'accepts method call including comma' do
      assert_render(<<-'HAML', <<-HTML)
        %body{ class: "#{"ab".gsub(/a/, 'b')}", data: { confirm: 'really?', disable: true }, id: 'c'.gsub(/c/, 'a') }
      HAML
        <body class='bb' data-confirm='really?' data-disable id='a'></body>
      HTML
    end

    it 'renders multi-byte chars as static attribute value' do
      assert_render(<<-'HAML', <<-HTML)
        %img{ alt: 'こんにちは' }
      HAML
        <img alt='こんにちは'>
      HTML
    end

    it 'sorts static attributes by name' do
      assert_render(<<-HAML, <<-HTML)
        %span{ :foo => "bar", :hoge => "piyo"}
        %span{ :hoge => "piyo", :foo => "bar"}
      HAML
        <span foo='bar' hoge='piyo'></span>
        <span foo='bar' hoge='piyo'></span>
      HTML
    end

    describe 'runtime attributes' do
      it 'renders runtime hash attribute' do
        assert_render(<<-'HAML', <<-HTML)
          - hash = { foo: 'bar' }
          %span{ hash }
        HAML
          <span foo='bar'></span>
        HTML
      end

      it 'renders multiples hashes' do
        assert_render(<<-'HAML', <<-HTML)
          - h1 = { a: 'b' }
          - h2 = { c: 'd' }
          - h3 = { e: 'f' }
          %span{ h1, h2, h3 }
        HAML
          <span a='b' c='d' e='f'></span>
        HTML
      end

      it 'renders multiples hashes and literal hash' do
        assert_render(<<-'HAML', <<-HTML)
          - h1 = { a: 'b' }
          - h2 = { c: 'd' }
          - h3 = { e: 'f' }
          %span{ h1, h2, h3, g: 'h', i: 'j' }
        HAML
          <span a='b' c='d' e='f' g='h' i='j'></span>
        HTML
      end
    end

    describe 'joinable attributes' do
      it 'joins class with a space' do
        assert_render(<<-'HAML', <<-HTML)
          - val = ['a', 'b', 'c']
          %p{ class: val }
          %p{ class: %w[a b c] }
          %p{ class: ['a', 'b', 'c'] }
        HAML
          <p class='a b c'></p>
          <p class='a b c'></p>
          <p class='a b c'></p>
        HTML
      end

      it 'joins attribute class and element class' do
        assert_render(<<-HAML, <<-HTML, compatible_only: :haml)
          .foo{ class: ['bar'] }
          .foo{ class: ['bar', nil] }
          .foo{ class: ['bar', 'baz'] }
        HAML
          <div class='bar foo'></div>
          <div class='bar foo'></div>
          <div class='bar baz foo'></div>
        HTML
      end

      it 'joins id with an underscore' do
        assert_render(<<-'HAML', <<-HTML)
          - val = ['a', 'b', 'c']
          %p{ id: val }
          %p{ id: %w[a b c] }
          %p{ id: ['a', 'b', 'c'] }
        HAML
          <p id='a_b_c'></p>
          <p id='a_b_c'></p>
          <p id='a_b_c'></p>
        HTML
      end

      it 'does not join others' do
        assert_render(<<-'HAML', <<-HTML)
          %a{ data: { value: [count: 1] } }
        HAML
          <a data-value='[{:count=&gt;1}]'></a>
        HTML
      end
    end

    describe 'deletable attributes' do
      it 'deletes attributes whose value is nil or false' do
        assert_render(<<-'HAML', <<-HTML)
          - hash = { checked: false }
          %input{ hash }
          %input{ checked: false }
          %input{ checked: nil }
          - checked = nil
          %input{ checked: checked }
          - checked = false
          %input{ checked: checked }
        HAML
          <input>
          <input>
          <input>
          <input>
          <input>
        HTML
      end

      it 'deletes some limited attributes with dynamic value' do
        assert_render(<<-'HAML', <<-HTML)
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
          <div class='bar' id='foo'></div>
          <div class='bar' id='foo'></div>
          <div class='bar' id='foo'></div>
          <div class='bar' id='foo'></div>
          <div class='bar' id='foo'></div>
          <div class='bar' id='foo'></div>
          <div class='bar' id='foo'></div>
          <div class='bar' id='foo'></div>
        HTML
      end

      # NOTE: This incompatibility will not be fixed for performance.
      it 'does not delete non-boolean attributes, for optimization' do
        assert_render(<<-'HAML', <<-HTML, compatible_only: []) # wontfix
          - val = false
          %a{ href: val }
          - val = nil
          %a{ href: val }
        HAML
          <a href='false'></a>
          <a href=''></a>
        HTML
      end
    end

    describe 'html escape' do
      it 'escapes attribute values on static attributes' do
        assert_render(<<-'HAML', <<-HTML, compatible_only: :faml)
          %a{title: "'"}
          %a{title: "'\""}
          %a{href: '/search?foo=bar&hoge=<fuga>'}
        HAML
          <a title='&#39;'></a>
          <a title='&#39;&quot;'></a>
          <a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>
        HTML
      end

      it 'escapes attribute values on dynamic attributes' do
        assert_render(<<-'HAML', <<-HTML, compatible_only: :faml)
          - title = "'\""
          - href  = '/search?foo=bar&hoge=<fuga>'
          %a{title: title}
          %a{href: href}
        HAML
          <a title='&#39;&quot;'></a>
          <a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>
        HTML
      end

      it 'escapes attribute values on hash attributes' do
        assert_render(<<-'HAML', <<-HTML, compatible_only: :faml)
          - title = { title: "'\"" }
          - href  = { href:  '/search?foo=bar&hoge=<fuga>' }
          %a{ title }
          %a{ href }
        HAML
          <a title='&#39;&quot;'></a>
          <a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>
        HTML
      end
    end

    describe 'nested attributes' do
      it 'renders data attribute by hash' do
        assert_render(<<-'HAML', <<-HTML)
          - hash = { bar: 'baz' }
          %span.foo{ data: hash }
        HAML
          <span class='foo' data-bar='baz'></span>
        HTML
      end

      it 'renders true attributes' do
        assert_render(<<-'HAML', <<-HTML, compatible_only: :haml)
          %span{ data: { disable: true } } bar
        HAML
          <span data-disable>bar</span>
        HTML
      end

      it 'renders nested hash whose value is variable' do
        assert_render(<<-'HAML', <<-HTML)
          - hash = { disable: true }
          %span{ data: hash } bar
        HAML
          <span data-disable>bar</span>
        HTML
      end

      it 'changes an underscore in a nested key to a hyphen' do
        assert_render(<<-'HAML', <<-HTML)
          %div{ data: { raw_src: 'foo' } }
        HAML
          <div data-raw-src='foo'></div>
        HTML
      end

      it 'changes an underscore in a nested dynamic attribute' do
        assert_render(<<-'HAML', <<-HTML)
          - hash = { raw_src: 'foo' }
          %div{ data: hash }
        HAML
          <div data-raw-src='foo'></div>
        HTML
      end
    end

    describe 'element class with attribute class' do
      it 'does not generate double classes' do
        assert_render(<<-HAML, <<-HTML)
          .item{ class: 'first' }
        HAML
          <div class='first item'></div>
        HTML
      end

      it 'does not generate double classes for a variable' do
        assert_render(<<-HAML, <<-HTML)
          - val = 'val'
          .element{ class: val }
        HAML
          <div class='element val'></div>
        HTML
      end

      it 'does not generate double classes for hash attributes' do
        assert_render(<<-HAML, <<-HTML)
          - hash = { class: 'val' }
          .element{ hash }
        HAML
          <div class='element val'></div>
        HTML
      end
    end

    describe 'element id with attribute id' do
      it 'does not generate double ids' do
        assert_render(<<-HAML, <<-HTML)
          #item{ id: 'first' }
        HAML
          <div id='item_first'></div>
        HTML
      end

      it 'does not generate double ids for a variable' do
        assert_render(<<-HAML, <<-HTML)
          - val = 'first'
          #item{ id: val }
        HAML
          <div id='item_first'></div>
        HTML
      end

      it 'does not generate double ids for hash attributes' do
        assert_render(<<-HAML, <<-HTML)
          - hash = { id: 'first' }
          #item{ hash }
        HAML
          <div id='item_first'></div>
        HTML
      end

      it 'does not generate double ids and classes for hash attributes' do
        assert_render(<<-HAML, <<-HTML)
          - hash = { id: 'first', class: 'foo' }
          #item.bar{ hash }
        HAML
          <div class='bar foo' id='item_first'></div>
        HTML
      end
    end
  end
end
