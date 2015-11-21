describe Hamlit::Engine do
  include RenderHelper

  describe 'script' do
    it 'renders optimized script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        1
        2
      HTML
        = '1'
        = __LINE__
      HAML
    end
  end

  describe 'old attributes' do
    it 'renders multi-line old attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span a='1' b='2'>2</span>
        3
      HTML
        %span{ a: __LINE__,
          b: __LINE__ }= __LINE__
        = __LINE__
      HAML
    end

    it 'renders optimized old attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span a='a' b='b'></span>
        3
        <span a='a' b='b'>5</span>
        6
      HTML
        %span{ a: 'a',
          b: 'b' }
        = __LINE__
        %span{ a: 'a',
          b: 'b' }= __LINE__
        = __LINE__
      HAML
    end
  end

  describe 'new attributes' do
    it 'renders multi-line new attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span a='1' b='1'>1</span>
        3
      HTML
        %span(a=__LINE__
         b=__LINE__)= __LINE__
        = __LINE__
      HAML
    end
  end
end
