class Hamlit::IndentTest < Haml::TestCase
  test 'accepts tab indentation' do
    assert_render(<<-HAML, <<-HTML)
      %p
      \t%a
    HAML
      <p>
      <a></a>
      </p>
    HTML
  end

  test 'accepts N-space indentation' do
    assert_render(<<-HAML, <<-HTML)
      %p
         %span
            foo
    HAML
      <p>
      <span>
      foo
      </span>
      </p>
    HTML
  end

  test 'accepts N-tab indentation' do
    assert_render(<<-HAML, <<-HTML)
      %p
      \t%span
      \t\tfoo
    HAML
      <p>
      <span>
      foo
      </span>
      </p>
    HTML
  end
end
