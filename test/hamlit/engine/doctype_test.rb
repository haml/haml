class Hamlit::DoctypeTest < Haml::TestCase
  test 'renders html5 doctype' do
    assert_render(<<-HAML, <<-HTML)
      !!!
    HAML
      <!DOCTYPE html>
    HTML
  end

  test 'renders xml doctype' do
    assert_render(<<-HAML, <<-HTML, format: :xhtml)
      !!! XML
    HAML
      <?xml version='1.0' encoding='utf-8' ?>
    HTML
  end
end
