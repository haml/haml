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

    it 'parses multi-line texts' do
      assert_render(<<-HAML, <<-HTML)
        %span
          %b
            hello
            world
      HAML
        <span>
        <b>
        hello
        world
        </b>
        </span>
      HTML
    end

    it 'skips empty lines' do
      assert_render(<<-HAML, <<-HTML)
        %span

          %b

            hello

      HAML
        <span>
        <b>
        hello
        </b>
        </span>
      HTML
    end
  end
end
