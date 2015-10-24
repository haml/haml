describe Hamlit::Filters do
  include RenderAssertion

  describe '#compile' do
    it 'renders plain filter' do
      assert_render(<<-'HAML', <<-HTML, compatible_only: :haml)
        :plain
          あ
          #{'い'}
      HAML
        あ
        い

      HTML
    end
  end
end
