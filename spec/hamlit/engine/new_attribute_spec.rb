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
  end
end
