describe Hamlit::Engine do
  describe 'multiline' do
    it 'joins multi-lines ending with pipe' do
      assert_render(<<-HAML, <<-HTML, compatible_only: [])
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

    it 'accepts invalid indent' do
      assert_render(<<-HAML, <<-HTML)
        %span
          %div
            = '1' + |
        '2' |
          %div
            3
      HAML
        <span>
        <div>
        12
        </div>
        <div>
        3
        </div>
        </span>
      HTML
    end
  end
end
