describe Hamlit::Engine do
  describe 'new attributes' do
    it 'renders attributes' do
      assert_render(<<-HAML, <<-HTML)
        %p(class='foo') bar
      HAML
        <p class='foo'>bar</p>
      HTML
    end
  end
end
