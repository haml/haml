describe Hamlit::Engine do
  include RenderHelper

  describe 'silent script' do
    it 'renders nothing' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
      HTML
        - _ = nil
        - _ = 3
        - _ = 'foo'
      HAML
    end

    it 'renders silent script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        5
      HTML
        - foo = 3
        - bar = 2
        = foo + bar
      HAML
    end

    it 'renders nested block' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        0
        1
        2
        3
        4
      HTML
        - 2.times do |i|
          = i
        2
        - 3.upto(4).each do |i|
          = i
      HAML
    end

    it 'renders if' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        ok
      HTML
        - if true
          ok
      HAML
    end

    it 'renders if-else' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        ok
        ok
      HTML
        - if true
          ok
        - else
          ng

        - if false
          ng

        - else
          ok
      HAML
    end

    it 'renders nested if-else' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        ok
        </span>
      HTML
        %span
          - if false
            ng
          - else
            ok
      HAML
    end

    it 'renders empty elsif statement' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        </span>
      HTML
        %span
          - if false
          - elsif false
      HAML
    end

    it 'renders empty else statement' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        </span>
      HTML
        %span
          - if false
            ng
          - else
      HAML
    end

    it 'renders empty when statement' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        </span>
      HTML
        %span
          - case
          - when false
      HAML
    end

    it 'accept if inside if-else' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        ok
      HTML
        - if false
          - if true
            ng
        - else
          ok
      HAML
    end

    it 'renders if-elsif' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        ok
        ok
      HTML
        - if false
        - elsif true
          ok

        - if false
        - elsif false
        - else
          ok
      HAML
    end

    it 'renders case-when' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        ok
      HTML
        - case 'foo'
        - when /\Ao/
          ng
        - when /\Af/
          ok
        - else
          ng
      HAML
    end

    it 'renders case-when with multiple candidates' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        ok
      HTML
        - case 'a'
        - when 'a', 'b'
          ok
      HAML
    end

    it 'renders begin-rescue' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        hello
        world
      HTML
        - begin
          - raise 'error'
        - rescue
          hello
        - ensure
          world
      HAML
    end

    it 'renders rescue with error' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        hello
      HTML
        - begin
          - raise 'error'
        - rescue RuntimeError => _e
          hello
      HAML
    end

    it 'joins a next line if a current line ends with ","' do
      assert_render(<<-HTML.unindent, "- foo = [',  \n     ']\n= foo")
        [&quot;, &quot;]
      HTML
    end

    it 'accepts illegal indent in continuing code' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        <div>
        3
        </div>
        </span>
      HTML
        %span
          %div
            - def foo(a, b); a + b; end
            - num = foo(1,
        2)
            = num
      HAML
    end

    it 'renders comment-only nested silent script' do
      assert_render('', <<-HAML.unindent)
        - if true
          - # comment only
      HAML
    end
  end
end
