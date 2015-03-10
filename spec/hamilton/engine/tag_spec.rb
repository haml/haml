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

    it 'parses a nested tag' do
      assert_render(<<-HAML, <<-HTML)
        %span
          %b
            hello
          %i
            %small world
      HAML
        <span>
        <b>
        hello
        </b>
        <i>
        <small>world</small>
        </i>
        </span>
      HTML
    end
  end
end
