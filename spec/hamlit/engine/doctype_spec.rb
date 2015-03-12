describe Hamlit::Engine do
  describe 'doctype' do
    it 'renders html5 doctype' do
      assert_render(<<-HAML, <<-HTML)
        !!!
      HAML
        <!DOCTYPE html>
      HTML
    end
  end
end
