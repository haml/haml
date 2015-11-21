describe Hamlit::Engine do
  include RenderHelper

  describe 'new attributes' do
    it 'renders attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <p class='foo'>bar</p>
      HTML
        %p(class='foo') bar
      HAML
    end

    it 'renders multiple attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <p a='1' b='2'>bar</p>
      HTML
        %p(a=1 b=2) bar
      HAML
    end

    it 'renders hyphenated attributes properly' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <p data-foo='bar'>bar</p>
      HTML
        %p(data-foo='bar') bar
      HAML
    end

    it 'renders multiply hyphenated attributes properly' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <p data-x-foo='bar'>bar</p>
      HTML
        %p(data-x-foo='bar') bar
      HAML
    end

    describe 'html escape' do
      it 'escapes attribute values on static attributes' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <a title='&#39;'></a>
          <a title='&#39;&quot;'></a>
          <a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>
        HTML
          %a(title="'")
          %a(title = "'\"")
          %a(href='/search?foo=bar&hoge=<fuga>')
        HAML
      end

      it 'escapes attribute values on dynamic attributes' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <a title='&#39;&quot;'></a>
          <a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>
        HTML
          - title = "'\""
          - href  = '/search?foo=bar&hoge=<fuga>'
          %a(title=title)
          %a(href=href)
        HAML
      end
    end

    describe 'element class with attribute class' do
      it 'does not generate double classes' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class='first item'></div>
        HTML
          .item(class='first')
        HAML
      end

      it 'does not generate double classes for a variable' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class='element val'></div>
        HTML
          - val = 'val'
          .element(class=val)
        HAML
      end
    end

    describe 'element id with attribute id' do
      it 'concatenates ids with underscore' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div id='item_first'></div>
        HTML
          #item(id='first')
        HAML
      end

      it 'concatenates ids with underscore for a variable' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div id='item_first'></div>
        HTML
          - val = 'first'
          #item(id=val)
        HAML
      end
    end
  end
end
