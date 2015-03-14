describe Hamlit::Engine do
  describe 'tag' do
    it 'renders one-line tag' do
      assert_render(<<-HAML, <<-HTML)
        %span hello
      HAML
        <span>hello</span>
      HTML
    end

    it 'renders multi-line tag' do
      assert_render(<<-HAML, <<-HTML)
        %span
          hello
      HAML
        <span>
        hello
        </span>
      HTML
    end

    it 'renders a nested tag' do
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

    it 'renders multi-line texts' do
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

    it 'renders classes' do
      assert_render(<<-HAML, <<-HTML)
        %span.foo-1.bar_A hello
      HAML
        <span class="foo-1 bar_A">hello</span>
      HTML
    end

    it 'renders ids' do
      assert_render(<<-HAML, <<-HTML)
        %span#Bar_0#bar-
          hello
      HAML
        <span id="Bar_0 bar-">
        hello
        </span>
      HTML
    end

    it 'renders ids and classes' do
      assert_render(<<-HAML, <<-HTML)
        %span#a.b#c.d hello
      HAML
        <span id="a c" class="b d">hello</span>
      HTML
    end

    it 'renders implicit div tag starting with id' do
      assert_render(<<-HAML, <<-HTML)
        #hello.world
      HAML
        <div id="hello" class="world" />
      HTML
    end

    it 'renders implicit div tag starting with class' do
      assert_render(<<-HAML, <<-HTML)
        .world#hello
          foo
      HAML
        <div class="world" id="hello">
        foo
        </div>
      HTML
    end
  end
end
