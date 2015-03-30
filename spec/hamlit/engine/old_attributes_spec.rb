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

    it 'renders attributes' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ data: { disable: true } } bar
      HAML
        <span data-disable>bar</span>
      HTML
    end

    it 'accepts even illegal input for haml' do
      assert_render(<<-'HAML', <<-HTML)
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

    it 'renders runtime hash attribute' do
      assert_render(<<-'HAML', <<-HTML)
        - hash = { foo: 'bar' }
        %span{ hash }
      HAML
        <span foo='bar'></span>
      HTML
    end
  end
end
