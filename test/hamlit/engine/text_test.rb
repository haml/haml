describe Hamlit::Engine do
  include RenderHelper

  describe 'text' do
    it 'renders string interpolation' do
      skip 'escape is not working well in truffleruby' if RUBY_ENGINE == 'truffleruby'
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        a3aa" [&quot;1&quot;, 2] b " !
        a{:a=&gt;3}
        <ht2ml>
      HTML
        #{ "a#{3}a" }a" #{["1", 2]} b " !
        a#{{ a: 3 }}
        <ht#{2}ml>
      HAML
    end

    it 'escapes all operators by backslash' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        a
        = 'a'
        -
      HTML
        = 'a'
        -
        \= 'a'
        \-
      HAML
    end

    it 'renders == operator' do
      skip 'escape is not working well in truffleruby' if RUBY_ENGINE == 'truffleruby'
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        =
        =
        <a>
        &lt;a&gt;
      HTML
        ===
        == =
        == <a>
        == #{'<a>'}
      HAML
    end

    it 'renders !== operator' do
      skip 'escape is not working well in truffleruby' if RUBY_ENGINE == 'truffleruby'
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        &lt;a&gt;
        <a>
        =
        =
      HTML
        == #{'<a>'}
        !== #{'<a>'}
        !===
        !== =
      HAML
    end

    it 'leaves empty spaces after backslash' do
      assert_render("       a\n", '\       a')
    end

    it 'renders spaced - properly' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <div>
        foo
        <div class='test'>- bar</div>
        <div class='test'>- baz</div>
        </div>
      HTML
        %div
          foo
          .test - bar
          .test - baz
      HAML
    end

    describe 'inline operator' do
      it 'renders ! operator' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <span><nyaa></span>
          <span><nyaa></span>
          <nyaa>
        HTML
          %span!#{'<nyaa>'}
          %span! #{'<nyaa>'}
          ! #{'<nyaa>'}
        HAML
      end

      it 'renders & operator' do
        skip 'escape is not working well in truffleruby' if RUBY_ENGINE == 'truffleruby'
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <span>&lt;nyaa&gt;</span>
          <span>&lt;nyaa&gt;</span>
          &lt;nyaa&gt;
        HTML
          %span& #{'<nyaa>'}
          %span&#{'<nyaa>'}
          & #{'<nyaa>'}
        HAML
      end

      it 'renders !, & operator right before a non-space character' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          &nbsp;
          &nbsp;
          !hello
          !hello
        HTML
          &nbsp;
          \&nbsp;
          !hello
          \!hello
        HAML
      end

      it 'renders &, ! operator inside a tag' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span>&nbsp;</span>
          <span>nbsp;</span>
          <span>nbsp;</span>
          <span>!hello</span>
          <span>hello</span>
          <span>hello</span>
        HTML
          %span &nbsp;
          %span&nbsp;
          %span& nbsp;
          %span !hello
          %span!hello
          %span! hello
        HAML
      end

      it 'does not accept backslash operator' do
        assert_render(<<-'HTML'.unindent, <<-'HAML'.unindent)
          <span>\    foo</span>
        HTML
          %span\    foo
        HAML
      end

      it 'renders != operator' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span><nyaa></span>
        HTML
          %span!= '<nyaa>'
        HAML
      end

      it 'renders !== operator' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <span><nyaa></span>
          <span><nyaa></span>
          <nyaa>
          <nyaa>
        HTML
          %span!==#{'<nyaa>'}
          %span!== #{'<nyaa>'}
          !==#{'<nyaa>'}
          !== #{'<nyaa>'}
        HAML
      end

      it 'renders &= operator' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <span>&lt;nyaa&gt;</span>
        HTML
          %span&= '<nyaa>'
        HAML
      end

      it 'renders &== operator' do
        skip 'escape is not working well in truffleruby' if RUBY_ENGINE == 'truffleruby'
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          =
          =
          &lt;p&gt;
        HTML
          &===
          &== =
          &== #{'<p>'}
        HAML
      end

      it 'renders ~ operator' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent, escape_html: false)
          <span>1</span>
        HTML
          %span~ 1
        HAML
      end
    end

    describe 'string interpolation' do
      it { assert_render("\n", '#{}') }
      it { assert_render("1\n", '1#{}') }
      it { assert_render("12\n", '1#{2}') }
      it { assert_render("}1\n", '}#{1}') }
      it { assert_render("12\n", '#{1}2') }
      it { assert_render("12345\n", '1#{ "2#{3}4" }5') }
      it { assert_render("123456789\n", '#{1}2#{3}4#{5}6#{7}8#{9}') }
      it { assert_render(%Q{'"!@$%^&*|=1112\n}, %q{'"!@$%^&*|=#{1}1#{1}2}) }
      it { assert_render("あ1\n", 'あ#{1}') }
      it { assert_render("あいう\n", 'あ#{"い"}う') }
      it { assert_render("a&lt;b&gt;c\n", 'a#{"<b>"}c') } if RUBY_ENGINE != 'truffleruby' # escape is not working in truffleruby
    end
  end
end
