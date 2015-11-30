describe Hamlit::Filters do
  include RenderHelper

  describe '#compile' do
    it 'renders plain filter' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        あ
        い

      HTML
        :plain
          あ
          #{'い'}
      HAML
    end
  end
end
