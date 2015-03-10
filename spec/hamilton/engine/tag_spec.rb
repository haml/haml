describe Hamilton::Engine do
  describe 'tag' do
    it 'parses one-line element' do
      assert_render(<<-HAML, <<-HTML)
        %span hello
      HAML
        <span>hello</span>
      HTML
    end

    it 'parses multi-line element' do
      assert_render(<<-HAML, <<-HTML)
        %span
          hello
      HAML
        <span>
        hello
        </span>
      HTML
    end
  end
end
