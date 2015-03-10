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

    it 'parses classes' do
      assert_render(<<-HAML, <<-HTML)
        %span.foo-1.bar_A hello
      HAML
        <span class="foo-1 bar_A">hello</span>
      HTML
    end

    it 'parses ids' do
      assert_render(<<-HAML, <<-HTML)
        %span#Bar_0#bar-
          hello
      HAML
        <span id="Bar_0 bar-">
        hello
        </span>
      HTML
    end

    it 'parses ids and classes' do
      assert_render(<<-HAML, <<-HTML)
        %span#a.b#c.d hello
      HAML
        <span id="a c" class="b d">hello</span>
      HTML
    end

    it 'parses implicit div tag starting with id' do
      assert_render(<<-HAML, <<-HTML)
        #hello.world
      HAML
        <div id="hello" class="world" />
      HTML
    end

    it 'parses implicit div tag starting with class' do
      assert_render(<<-HAML, <<-HTML)
        .world#hello
          foo
      HAML
        <div id="hello" class="world">
        foo
        </div>
      HTML
    end
  end
end
