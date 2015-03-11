describe Hamilton::Engine do
  describe 'silent script' do
    it 'parses silent script' do
      assert_render(<<-HAML, <<-HTML)
        - foo = 3
        - bar = 2
        = foo + bar
      HAML
        5
      HTML
    end
  end
end
