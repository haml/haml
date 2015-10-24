class Hamlit::MultilineTest < Haml::TestCase
  test 'joins multi-lines ending with pipe' do
    assert_render(<<-HAML, <<-HTML)
      a |
        b |
    HAML
      a b 
    HTML
  end

  test 'renders multi lines' do
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

  test 'accepts invalid indent' do
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
