describe Haml::Engine do
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

    it 'renders rdfa doctype' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent, format: :xhtml)
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd">
      HTML
        !!! RDFa
      HAML
    end
  end
end
