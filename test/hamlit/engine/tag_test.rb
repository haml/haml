describe Hamlit::Engine do
  include RenderAssertion

  describe 'tag' do
    it 'renders one-line tag' do
      assert_render(<<-HAML, <<-HTML)
        %span hello
      HAML
        <span>hello</span>
      HTML
    end

    it 'accepts multi-line =' do
      assert_render(<<-HAML, <<-HTML)
        %span= 'hello'.gsub('hell',
          '')
      HAML
        <span>o</span>
      HTML
    end

    it 'renders multi-line tag' do
      skip
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
        <span class='foo-1 bar_A'>hello</span>
      HTML
    end

    it 'renders ids only last one' do
      assert_render(<<-HAML, <<-HTML)
        %span#Bar_0#bar-
          hello
      HAML
        <span id='bar-'>
        hello
        </span>
      HTML
    end

    it 'renders ids and classes' do
      assert_render(<<-HAML, <<-HTML)
        %span#a.b#c.d hello
      HAML
        <span class='b d' id='c'>hello</span>
      HTML
    end

    it 'renders implicit div tag starting with id' do
      assert_render(<<-HAML, <<-HTML)
        #hello.world
      HAML
        <div class='world' id='hello'></div>
      HTML
    end

    it 'renders implicit div tag starting with class' do
      assert_render(<<-HAML, <<-HTML)
        .world#hello
          foo
      HAML
        <div class='world' id='hello'>
        foo
        </div>
      HTML
    end

    it 'renders large-case tag' do
      assert_render(<<-HAML, <<-HTML)
        %SPAN
          foo
      HAML
        <SPAN>
        foo
        </SPAN>
      HTML
    end

    it 'renders h1 tag' do
      assert_render(<<-HAML, <<-HTML)
        %h1 foo
      HAML
        <h1>foo</h1>
      HTML
    end

    it 'renders tag including hyphen or underscore' do
      assert_render(<<-HAML, <<-HTML)
        %-_ foo
      HAML
        <-_>foo</-_>
      HTML
    end

    it 'does not render silent script just after a tag' do
      assert_render(<<-HAML, <<-HTML)
        %span- raise 'a'
      HAML
        <span->raise 'a'</span->
      HTML
    end

    it 'renders a text just after attributes' do
      assert_render(<<-HAML, <<-HTML)
        %span{a: 2}a
      HAML
        <span a='2'>a</span>
      HTML
    end

    it 'strips a text' do
      assert_render(<<-HAML, <<-HTML)
        %span    foo
      HAML
        <span>foo</span>
      HTML
    end

    it 'ignores spaces after tag' do
      assert_render("%span  \n  a", <<-HTML)
        <span>
        a
        </span>
      HTML
    end

    it 'parses self-closing tag' do
      assert_render(<<-HAML, <<-HTML, format: :xhtml)
        %div/
        %div
      HAML
        <div />
        <div></div>
      HTML
    end

    describe 'whitespace removal' do
      it 'removes outer whitespace by >' do
        assert_render(<<-HAML, <<-HTML)
          %span> a
          %span b
          %span c
          %span>
            d
          %span
            e
          %span f
        HAML
          <span>a</span><span>b</span>
          <span>c</span><span>
          d
          </span><span>
          e
          </span>
          <span>f</span>
        HTML
      end

      it 'removes outer whitespace by > from inside of block' do
        skip
        assert_render(<<-HAML, <<-HTML)
          %span a
          - if true
            %span>
              b
          %span
            c
        HAML
          <span>a</span><span>
          b
          </span><span>
          c
          </span>
        HTML
      end

      it 'removes whitespaces inside block script' do
        skip
        assert_render(<<-HAML, <<-HTML)
          %span<
            = 2.times do
              = 'foo'
            %span> bar
        HAML
          <span>foofoo2<span>bar</span></span>
        HTML
      end

      it 'removes whitespace inside script inside silent script' do
        skip
        assert_render(<<-HAML, <<-HTML)
          .bar<
            - 3.times do
              = 'foo'
        HAML
          <div class='bar'>foofoofoo</div>
        HTML
      end

      it 'removes whitespace inside script recursively' do
        skip
        assert_render(<<-HAML, <<-HTML)
          .foo<
            - 1.times do
              = 2.times do
                - 2.times do
                  = 1.times do
                    = 'bar'
        HAML
          <div class='foo'>bar1bar1bar1bar12</div>
        HTML
      end

      it 'does not remove whitespace after string interpolation' do
        assert_render(<<-'HAML', <<-HTML, compatible_only: :faml)
          %div<
            #{'hello'}
            world
        HAML
          <div>hello
          world</div>
        HTML
      end

      it 'removes whitespace inside script inside silent script' do
        skip
        assert_render(<<-HAML, <<-HTML, compatible_only: :faml)
          .bar<
            - 1.times do
              = '1'
              = '2'
        HAML
          <div class='bar'>1
          2</div>
        HTML
      end
    end
  end
end
