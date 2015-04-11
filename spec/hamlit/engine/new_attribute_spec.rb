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

    describe 'html escape' do
      it 'escapes attribute values on static attributes' do
        assert_render(<<-'HAML', <<-HTML)
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
        assert_render(<<-'HAML', <<-HTML)
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
  end
end
