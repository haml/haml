describe Hamlit::Parser do
  describe 'preservation' do
    it 'renders whitespace preservation operator' do
      assert_render(<<-'HAML', <<-HTML)
        ~ "<code>hello\nworld</code>"
      HAML
        <code>hello&#x000A;world</code>
      HTML
    end
  end
end
