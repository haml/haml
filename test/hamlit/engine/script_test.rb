describe Hamlit::Engine do
  include RenderHelper

  describe 'script' do
    it 'renders one-line script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        3
        <span>12</span>
      HTML
        = 1 + 2
        %span= 3 * 4
      HAML
    end

    it 'renders dynamic interpolated string' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        hello nya world
      HTML
        - nya = 'nya'
        = "hello #{nya} world"
      HAML
    end

    it 'renders array with escape_html: false' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent, escape_html: false)
        ["<", ">"]
      HTML
        = ['<', '>']
      HAML
    end

    it 'renders one-line script with comment' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)

        ##
        [&quot;#&quot;, &quot;#&quot;]
      HTML
        = # comment_only
        = '#' + "#" # = 3 #
        = ['#',
          "#"]  # comment
      HAML
    end

    it 'renders multi-lines script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        3
        4 / 2
        <a>-1</a>
        </span>
      HTML
        %span
          = 1 + 2
          4 / 2
          %a= 3 - 4
      HAML
    end

    it 'renders block script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        0
        1
        2
        34
      HTML
        = 3.times do |i|
          = i
        4
      HAML
    end

    it 'renders tag internal block script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        0
        1</span>
      HTML
        %span
          = 1.times do |i|
            = i
      HAML
    end

    it 'renders block and a variable with spaces' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        0
      HTML
        - 1.times do | i |
          = i
      HAML
    end

    it 'accepts a continuing script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        3
      HTML
        - def foo(a, b); a + b; end
        = foo(1,
        2)
      HAML
    end

    it 'renders !=' do
      assert_render(<<-HTML.unindent.strip, <<-HAML.unindent, escape_html: false)
        <"&>
        <"&>
      HTML
        != '<"&>'
        != '<"&>'.tap do |str|
          -# no operation
      HAML
    end

    it 'renders &=' do
      assert_render(<<-HTML.unindent.strip, <<-HAML.unindent, escape_html: false)
        &lt;&quot;&amp;&gt;
        &lt;&quot;&amp;&gt;
      HTML
        &= '<"&>'
        &= '<"&>'.tap do |str|
          -# no operation
      HAML
    end

    it 'regards ~ operator as =' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        &lt;code&gt;hello
        world&lt;/code&gt;
      HTML
        ~ "<code>hello\nworld</code>"
      HAML
    end

    it 'renders comment-only nested script' do
      assert_render('1', <<-HAML.unindent)
        = 1.times do # comment
          - # comment only
      HAML
    end

    it 'renders inline script with comment' do
      assert_render(%Q|<span>3</span>\n|, %q|%span= 1 + 2 # comments|)
    end
  end
end
