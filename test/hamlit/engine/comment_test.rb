describe Hamlit::Engine do
  include RenderHelper

  describe 'comment' do
    it 'renders html comment' do
      assert_render(%Q|<!-- comments -->\n|, '/ comments')
    end

    it 'strips html comment ignoring around spcaes' do
      assert_render(%Q|<!-- comments -->\n|, '/   comments    ')
    end

    it 'accepts backslash-only line in a comment' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <!--

        -->
      HTML
        /
          \
      HAML
    end

    it 'renders a deeply indented comment starting with backslash' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <!--
               a
        -->
        <!--
        a
        -->
      HTML
        /
          \       a
        /
          a
      HAML
    end

    it 'ignores multiline comment' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        ok
      HTML
        -# if true
          - raise 'ng'
            = invalid script
                too deep indent
        ok
      HAML
    end
  end
end
