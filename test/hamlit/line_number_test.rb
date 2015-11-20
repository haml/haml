describe Hamlit::Engine do
  include RenderAssertion

  describe 'old attributes' do
    it 'renders old attributes lineno' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ a: __LINE__,
          b: __LINE__ }= __LINE__
        = __LINE__
      HAML
        <span a='1' b='2'>2</span>
        3
      HTML
    end
  end

  describe 'new attributes' do
    it 'renders multi-line new attributes lineno' do
      assert_render(<<-HAML, <<-HTML, compatible_only: :haml)
        %span(a=__LINE__
         b=__LINE__)= __LINE__
        = __LINE__
      HAML
        <span a='1' b='1'>1</span>
        3
      HTML
    end
  end
end
