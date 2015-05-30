describe Hamlit::Parser do
  describe 'comment' do
    it 'renders html comment' do
      assert_render(<<-HAML, <<-HTML)
        / comments
      HAML
        <!-- comments -->
      HTML
    end

    it 'strips html comment ignoring around spcaes' do
      assert_render('/   comments    ', <<-HTML)
        <!-- comments -->
      HTML
    end

    it 'accepts backslash-only line in a comment' do
      assert_render(<<-'HAML', <<-HTML)
        /
          \
      HAML
        <!--

        -->
      HTML
    end

    it 'ignores multiline comment' do
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
end
