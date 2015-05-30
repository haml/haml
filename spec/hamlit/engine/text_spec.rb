describe Hamlit::Engine do
  describe 'text' do
    it 'renders string interpolation' do
      assert_render(<<-'HAML', <<-HTML)
        #{ "a#{3}a" }a" #{["1", 2]} b " !
        a#{{ a: 3 }}
        <ht#{2}ml>
      HAML
        a3aa" ["1", 2] b " !
        a{:a=>3}
        <ht2ml>
      HTML
    end

    it 'renders . or # which is not continued by tag name' do
      assert_render(<<-HAML, <<-HTML)
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

    it 'leaves empty spaces after backslash' do
      expect(render_string('\       a')).to eq("       a\n")
    end
  end
end
