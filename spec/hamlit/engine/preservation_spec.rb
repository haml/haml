describe Hamlit::Parser do
  describe 'preservation' do
    it 'renders whitespace preservation operator' do
      assert_render(<<-'HAML', <<-HTML)
        ~ "<code>hello\nworld</code>"
      HAML
        &lt;code&gt;hello&amp;#x000A;world&lt;/code&gt;
      HTML
    end
  end
end
