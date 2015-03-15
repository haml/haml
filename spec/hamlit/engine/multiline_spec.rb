describe Hamlit::Engine do
  describe 'multiline' do
    it 'joins multi-lines ending with pipe' do
      assert_render(<<-HAML, <<-HTML)
        a |
          b |
      HAML
        a b
      HTML
    end

    it 'renders multi lines' do
      assert_render(<<-HAML, <<-HTML)
        = 'a' +  |
             'b' + |
             'c' |
        'd'
      HAML
        abc
        'd'
      HTML
    end
  end
end
