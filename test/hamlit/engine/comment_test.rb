class Hamlit::CommentTest < Haml::TestCase
  test 'renders html comment' do
    assert_render(<<-HAML, <<-HTML)
      / comments
    HAML
      <!-- comments -->
    HTML
  end

  test 'strips html comment ignoring around spcaes' do
    assert_render('/   comments    ', <<-HTML)
      <!-- comments -->
    HTML
  end

  test 'accepts backslash-only line in a comment' do
    assert_render(<<-'HAML', <<-HTML)
      /
        \
    HAML
      <!--

      -->
    HTML
  end

  test 'renders a deeply indented comment starting with backslash' do
    assert_render(<<-'HAML', <<-HTML)
      /
        \       a
      /
        a
    HAML
      <!--
             a
      -->
      <!--
      a
      -->
    HTML
  end

  test 'ignores multiline comment' do
    assert_render(<<-'HAML', <<-HTML)
      -# if true
        - raise 'ng'
          = invalid script
              too deep indent
      ok
    HAML
      ok
    HTML
  end
end
