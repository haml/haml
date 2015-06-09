describe Hamlit::Engine do
  describe 'new attributes' do
    it 'renders attributes' do
      assert_render(<<-HAML, <<-HTML)
        %p(class='foo') bar
      HAML
        <p class='foo'>bar</p>
      HTML
    end

    it 'renders multiple attributes' do
      assert_render(<<-HAML, <<-HTML)
        %p(a=1 b=2) bar
      HAML
        <p a='1' b='2'>bar</p>
      HTML
    end

    it 'renders multi-line attributes properly' do
      assert_render(<<-HAML, <<-HTML, compatible_only: :faml)
        %span(a=__LINE__
         b=__LINE__)
        = __LINE__
      HAML
        <span a='1' b='2'></span>
        3
      HTML
    end

    describe 'html escape' do
      it 'escapes attribute values on static attributes' do
        assert_render(<<-'HAML', <<-HTML, compatible_only: :faml)
          %a(title="'")
          %a(title = "'\"")
          %a(href='/search?foo=bar&hoge=<fuga>')
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
          %a(title=title)
          %a(href=href)
        HAML
          <a title='&#39;&quot;'></a>
          <a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>
        HTML
      end
    end

    describe 'element class with attribute class' do
      it 'does not generate double classes' do
        assert_render(<<-HAML, <<-HTML)
          .item(class='first')
        HAML
          <div class='first item'></div>
        HTML
      end

      it 'does not generate double classes for a variable' do
        assert_render(<<-HAML, <<-HTML)
          - val = 'val'
          .element(class=val)
        HAML
          <div class='element val'></div>
        HTML
      end
    end

    describe 'element id with attribute id' do
      it 'concatenates ids with underscore' do
        assert_render(<<-HAML, <<-HTML)
          #item(id='first')
        HAML
          <div id='item_first'></div>
        HTML
      end

      it 'concatenates ids with underscore for a variable' do
        assert_render(<<-HAML, <<-HTML)
          - val = 'first'
          #item(id=val)
        HAML
          <div id='item_first'></div>
        HTML
      end
    end
  end
end
