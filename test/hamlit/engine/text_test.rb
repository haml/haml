describe Hamlit::Engine do
  include RenderAssertion

  describe 'text' do
    it 'renders string interpolation' do
      assert_render(<<-'HAML', <<-HTML)
        #{ "a#{3}a" }a" #{["1", 2]} b " !
        a#{{ a: 3 }}
        <ht#{2}ml>
      HAML
        a3aa" [&quot;1&quot;, 2] b " !
        a{:a=&gt;3}
        <ht2ml>
      HTML
    end

    it 'escapes all operators by backslash' do
      assert_render(<<-'HAML', <<-HTML)
        = 'a'
        -
        \= 'a'
        \-
      HAML
        a
        = 'a'
        -
      HTML
    end

    it 'renders == operator' do
      assert_render(<<-'HAML', <<-HTML)
        ===
        == =
        == <a>
        == #{'<a>'}
      HAML
        =
        =
        <a>
        &lt;a&gt;
      HTML
    end

    it 'renders !== operator' do
      assert_render(<<-'HAML', <<-HTML)
        == #{'<a>'}
        !== #{'<a>'}
        !===
        !== =
      HAML
        &lt;a&gt;
        <a>
        =
        =
      HTML
    end

    it 'leaves empty spaces after backslash' do
      assert_render('\       a', "       a\n", skip_unindent: true)
    end

    it 'renders spaced - properly' do
      assert_render(<<-HAML, <<-'HTML')
        %div
          foo
          .test - bar
          .test - baz
      HAML
        <div>
        foo
        <div class='test'>- bar</div>
        <div class='test'>- baz</div>
        </div>
      HTML
    end

    describe 'inline operator' do
      it 'renders ! operator' do
        assert_render(<<-'HAML', <<-'HTML')
          %span!#{'<nyaa>'}
          %span! #{'<nyaa>'}
          ! #{'<nyaa>'}
        HAML
          <span><nyaa></span>
          <span><nyaa></span>
          <nyaa>
        HTML
      end

      it 'renders & operator' do
        assert_render(<<-'HAML', <<-'HTML')
          %span& #{'<nyaa>'}
          %span&#{'<nyaa>'}
          & #{'<nyaa>'}
        HAML
          <span>&lt;nyaa&gt;</span>
          <span>&lt;nyaa&gt;</span>
          &lt;nyaa&gt;
        HTML
      end

      it 'renders !, & operator right before a non-space character' do
        assert_render(<<-'HAML', <<-'HTML', compatible_only: :haml)
          &nbsp;
          \&nbsp;
          !hello
          \!hello
        HAML
          &nbsp;
          &nbsp;
          !hello
          !hello
        HTML
      end

      it 'renders &, ! operator inside a tag' do
        assert_render(<<-HAML, <<-HTML)
          %span &nbsp;
          %span&nbsp;
          %span& nbsp;
          %span !hello
          %span!hello
          %span! hello
        HAML
          <span>&nbsp;</span>
          <span>nbsp;</span>
          <span>nbsp;</span>
          <span>!hello</span>
          <span>hello</span>
          <span>hello</span>
        HTML
      end

      it 'does not accept backslash operator' do
        assert_render(<<-'HAML', <<-'HTML')
          %span\    foo
        HAML
          <span>\    foo</span>
        HTML
      end

      it 'renders != operator' do
        assert_render(<<-'HAML', <<-'HTML')
          %span!= '<nyaa>'
        HAML
          <span><nyaa></span>
        HTML
      end

      it 'renders !== operator' do
        assert_render(<<-'HAML', <<-'HTML')
          %span!==#{'<nyaa>'}
          %span!== #{'<nyaa>'}
          !==#{'<nyaa>'}
          !== #{'<nyaa>'}
        HAML
          <span><nyaa></span>
          <span><nyaa></span>
          <nyaa>
          <nyaa>
        HTML
      end

      it 'renders &= operator' do
        assert_render(<<-'HAML', <<-'HTML', escape_html: false)
          %span&= '<nyaa>'
        HAML
          <span>&lt;nyaa&gt;</span>
        HTML
      end

      it 'renders &== operator' do
        assert_render(<<-'HAML', <<-'HTML')
          &===
          &== =
          &== #{'<p>'}
        HAML
          =
          =
          &lt;p&gt;
        HTML
      end

      it 'renders ~ operator' do
        assert_render(<<-HAML, <<-HTML, escape_html: false)
          %span~ 1
        HAML
          <span>1</span>
        HTML
      end
    end

    describe 'string interpolation' do
      specify { assert_render('#{}', "\n") }
      specify { assert_render('1#{}', "1\n") }
      specify { assert_render('1#{2}', "12\n") }
      specify { assert_render('}#{1}', "}1\n") }
      specify { assert_render('#{1}2', "12\n") }
      specify { assert_render('1#{ "2#{3}4" }5', "12345\n") }
      specify { assert_render('#{1}2#{3}4#{5}6#{7}8#{9}', "123456789\n") }
      specify { assert_render(%q{'"!@$%^&*|=#{1}1#{1}2}, %Q{'"!@$%^&*|=1112\n}) }
      specify { assert_render('あ#{1}', "あ1\n") }
      specify { assert_render('あ#{"い"}う', "あいう\n") }
      specify { assert_render('a#{"<b>"}c', "a&lt;b&gt;c\n") }
    end
  end
end
