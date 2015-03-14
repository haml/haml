describe Hamlit::Engine do
  describe 'html attributes' do
    it 'parses attributes' do
      assert_render(<<-HAML, <<-HTML)
        %span{class: 'foo'} bar
      HAML
        <span class="foo">bar</span>
      HTML
    end

    it 'parses attributes' do
      assert_render(<<-HAML, <<-HTML)
        %span{ data: 2 } bar
      HAML
        <span data="2">bar</span>
      HTML
    end

    it 'parses attributes' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ :class => "foo" } bar
      HAML
        <span class="foo">bar</span>
      HTML
    end

    it 'parses attributes' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ :class => "foo", id: 'bar' } bar
      HAML
        <span class="foo" id="bar">bar</span>
      HTML
    end
  end
end
