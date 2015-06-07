describe Hamlit::Engine do
  describe 'tab indent' do
    it 'accepts tab indentation', skipdoc: true do
      assert_render(<<-HAML, <<-HTML, compatible_only: :haml)
        %p
        \t%a
      HAML
        <p>
        <a></a>
        </p>
      HTML
    end
  end
end
