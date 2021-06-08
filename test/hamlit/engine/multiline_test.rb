describe Hamlit::Engine do
  include RenderHelper

  describe 'multiline' do
    it 'joins multi-lines ending with pipe' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        a b 
      HTML
        a |
          b |
      HAML
    end

    it 'renders multi lines' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        abc
        'd'
      HTML
        = 'a' +  |
             'b' + |
             'c' |
        'd'
      HAML
    end

    it 'accepts invalid indent' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        <div>
        12
        </div>
        <div>
        3
        </div>
        </span>
      HTML
        %span
          %div
            = '1' + |
        '2' |
          %div
            3
      HAML
    end
  end
end
