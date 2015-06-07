describe Hamlit::Engine do
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

    it 'renders . or # which is not continued by tag name' do
      assert_render(<<-HAML, <<-HTML, compatible_only: [], error_with: :haml)
        .
        .*
        #
        #+
      HAML
        .
        .*
        #
        #+
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
      expect(render_string('\       a')).to eq("       a\n")
    end

    it 'renders ! operator' do
      assert_render(<<-'HAML', <<-HTML, compatible_only: :faml)
        aaa#{'<a>'}
        !aaa#{'<a>'}
        ! aaa#{'<a>'}
        !  aaa#{'<a>'}
        !!aa
      HAML
        aaa&lt;a&gt;
        aaa<a>
        aaa<a>
        aaa<a>
        !aa
      HTML
    end

    describe 'string interpolation' do
      specify { assert_render('#{}', "\n") }
      specify { assert_render('1#{}', "1\n") }
      specify { assert_render('1#{2}', "12\n") }
      specify { assert_render('1#{2', "1\#{2\n", error_with: [:haml, :faml]) }
      specify { assert_render('}#{1}', "}1\n") }
      specify { assert_render('#{1}2', "12\n") }
      specify { assert_render('1#{ "2#{3}4" }5', "12345\n") }
      specify { assert_render('#{1}2#{3}4#{5}6#{7}8#{9}', "123456789\n") }
      specify { assert_render(%q{'"!@$%^&*|=#{1}1#{1}2}, %Q{'"!@$%^&*|=1112\n}) }
      specify { assert_render('あ#{1}', "あ1\n") }
      specify { assert_render('あ#{"い"}う', "あいう\n") }
      specify { assert_render('a#{"<b>"}c', "a&lt;b&gt;c\n") }
      specify(skipdoc: true) { assert_render(":plain\n  あ\n  \#{'い'}", "あ\nい\n\n", compatible_only: :haml) }
    end
  end
end
