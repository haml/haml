describe Hamlit::Filters::Css do
  describe '#compile' do
    it 'renders css' do
      assert_render(<<-HAML, <<-HTML)
        :css
          .foo {
            width: 100px;
          }
      HAML
        <style>
          .foo {
            width: 100px;
          }
        </style>
      HTML
    end
  end
end
