describe Hamlit::Engine do
  include RenderHelper

  describe 'doctype' do
    it 'renders html5 doctype' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <!DOCTYPE html>
      HTML
        !!!
      HAML
    end

    it 'renders xml doctype' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent, format: :xhtml)
        <?xml version='1.0' encoding='utf-8' ?>
      HTML
        !!! XML
      HAML
    end
  end
end
