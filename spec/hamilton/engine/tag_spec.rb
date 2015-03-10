describe Hamilton::Engine do
  describe 'tag' do
    it 'parses one-line tag' do
      assert_render(<<-HAML, <<-HTML)
        %span hello
      HAML
        <span>hello</span>
      HTML
    end

    it 'parses multi-line tag' do
      assert_render(<<-HAML, <<-HTML)
        %span
          hello
      HAML
        <span>
        hello
        </span>
      HTML
    end

    it 'parses multi-line tag with multiple texts' do
      assert_render(<<-HAML, <<-HTML)
        %span
          hello
          world
      HAML
        <span>
        hello
        world
        </span>
      HTML
    end
  end
end
