describe Hamlit::Engine do
  include RenderHelper

  describe 'tag' do
    it 'renders one-line tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>hello</span>
      HTML
        %span hello
      HAML
    end

    it 'accepts multi-line =' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>o</span>
      HTML
        %span= 'hello'.gsub('hell',
          '')
      HAML
    end

    it 'renders multi-line tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        hello
        </span>
      HTML
        %span
          hello
      HAML
    end

    it 'renders a nested tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        <b>
        hello
        </b>
        <i>
        <small>world</small>
        </i>
        </span>
      HTML
        %span
          %b
            hello
          %i
            %small world
      HAML
    end

    it 'renders multi-line texts' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        <b>
        hello
        world
        </b>
        </span>
      HTML
        %span
          %b
            hello
            world
      HAML
    end

    it 'ignores empty lines' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        <b>
        hello
        </b>
        </span>
      HTML
        %span

          %b

            hello

      HAML
    end

    it 'renders classes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span class='foo-1 bar_A'>hello</span>
      HTML
        %span.foo-1.bar_A hello
      HAML
    end

    it 'renders ids only last one' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span id='bar-'>
        hello
        </span>
      HTML
        %span#Bar_0#bar-
          hello
      HAML
    end

    it 'renders ids and classes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span class='b d' id='c'>hello</span>
      HTML
        %span#a.b#c.d hello
      HAML
    end

    it 'renders implicit div tag starting with id' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class='world' id='hello'></div>
      HTML
        #hello.world
      HAML
    end

    it 'renders implicit div tag starting with class' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class='world' id='hello'>
        foo
        </div>
      HTML
        .world#hello
          foo
      HAML
    end

    it 'renders large-case tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <SPAN>
        foo
        </SPAN>
      HTML
        %SPAN
          foo
      HAML
    end

    it 'renders h1 tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <h1>foo</h1>
      HTML
        %h1 foo
      HAML
    end

    it 'renders tag including hyphen or underscore' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <-_>foo</-_>
      HTML
        %-_ foo
      HAML
    end

    it 'does not render silent script just after a tag' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <span->raise 'a'</span->
      HTML
        %span- raise 'a'
      HAML
    end

    it 'renders a text just after attributes' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <span a='2'>a</span>
      HTML
        %span{a: 2}a
      HAML
    end

    it 'strips a text' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>foo</span>
      HTML
        %span    foo
      HAML
    end

    it 'ignores spaces after tag' do
      assert_render(<<-HTML.unindent, "%span  \n  a")
        <span>
        a
        </span>
      HTML
    end

    it 'parses self-closing tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent, format: :xhtml)
        <div />
        <div></div>
      HTML
        %div/
        %div
      HAML
    end

    describe 'whitespace removal' do
      it 'removes outer whitespace by >' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span>a</span><span>b</span>
          <span>c</span><span>
          d
          </span><span>
          e
          </span>
          <span>f</span>
        HTML
          %span> a
          %span b
          %span c
          %span>
            d
          %span
            e
          %span f
        HAML
      end

      it 'removes outer whitespace by > from inside of block' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span>a</span><span>
          b
          </span><span>
          c
          </span>
        HTML
          %span a
          - if true
            %span>
              b
          %span
            c
        HAML
      end

      it 'removes whitespaces inside block script' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span>foofoo2<span>bar</span></span>
        HTML
          %span<
            = 2.times do
              = 'foo'
            %span> bar
        HAML
      end

      it 'removes whitespace inside script inside silent script' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class='bar'>foofoofoo</div>
        HTML
          .bar<
            - 3.times do
              = 'foo'
        HAML
      end

      it 'removes whitespace inside script recursively' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class='foo'>bar1bar1bar1bar12</div>
        HTML
          .foo<
            - 1.times do
              = 2.times do
                - 2.times do
                  = 1.times do
                    = 'bar'
        HAML
      end

      it 'does not remove whitespace after string interpolation' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <div>helloworld</div>
        HTML
          %div<
            #{'hello'}
            world
        HAML
      end

      it 'removes whitespace inside script inside silent script' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <div class='bar'>12</div>
        HTML
          .bar<
            - 1.times do
              = '1'
              = '2'
        HAML
      end
    end
  end
end
