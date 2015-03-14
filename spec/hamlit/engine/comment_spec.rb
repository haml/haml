describe Hamlit::Parser do
  describe 'comment' do
    it 'renders html comment' do
      assert_render(<<-HAML, <<-HTML)
        / comments
      HAML
        <!-- comments -->
      HTML
    end

    it 'strips html comment ignoring around spcaes' do
      assert_render('/   comments    ', <<-HTML)
        <!-- comments -->
      HTML
    end
  end
end
