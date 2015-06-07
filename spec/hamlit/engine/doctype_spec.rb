describe Hamlit::Engine do
  describe 'doctype' do
    it 'renders html5 doctype' do
      assert_render(<<-HAML, <<-HTML)
        !!!
      HAML
        <!DOCTYPE html>
      HTML
    end

    it 'renders xml doctype' do
      assert_render(<<-HAML, <<-HTML, format: :xhtml)
        !!! XML
      HAML
        <?xml version='1.0' encoding='utf-8' ?>
      HTML
    end
  end
end
