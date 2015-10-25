describe Hamlit::Engine do
  include RenderAssertion

  describe 'silent script' do
    it 'renders nothing' do
      assert_render(<<-HAML, <<-HTML)
        - nil
        - 3
        - 'foo'
      HAML
      HTML
    end

    it 'renders silent script' do
      assert_render(<<-HAML, <<-HTML)
        - foo = 3
        - bar = 2
        = foo + bar
      HAML
        5
      HTML
    end

    it 'renders nested block' do
      assert_render(<<-HAML, <<-HTML)
        - 2.times do |i|
          = i
        2
        - 3.upto(4).each do |i|
          = i
      HAML
        0
        1
        2
        3
        4
      HTML
    end

    it 'renders if' do
      assert_render(<<-HAML, <<-HTML)
        - if true
          ok
      HAML
        ok
      HTML
    end

    it 'renders if-else' do
      assert_render(<<-HAML, <<-HTML)
        - if true
          ok
        - else
          ng

        - if false
          ng

        - else
          ok
      HAML
        ok
        ok
      HTML
    end

    it 'renders nested if-else' do
      assert_render(<<-'HAML', <<-HTML)
        %span
          - if false
            ng
          - else
            ok
      HAML
        <span>
        ok
        </span>
      HTML
    end

    it 'renders empty elsif statement' do
      assert_render(<<-'HAML', <<-HTML, compatible_only: :haml, error_with: :faml)
        %span
          - if false
          - elsif false
      HAML
        <span>
        </span>
      HTML
    end

    it 'renders empty else statement' do
      assert_render(<<-'HAML', <<-HTML, compatible_only: :haml, error_with: :faml)
        %span
          - if false
            ng
          - else
      HAML
        <span>
        </span>
      HTML
    end

    it 'renders empty when statement' do
      assert_render(<<-'HAML', <<-HTML, compatible_only: :haml, error_with: :faml)
        %span
          - case
          - when false
      HAML
        <span>
        </span>
      HTML
    end

    it 'accept if inside if-else' do
      assert_render(<<-'HAML', <<-HTML)
        - if false
          - if true
            ng
        - else
          ok
      HAML
        ok
      HTML
    end

    it 'renders if-elsif' do
      assert_render(<<-HAML, <<-HTML)
        - if false
        - elsif true
          ok

        - if false
        - elsif false
        - else
          ok
      HAML
        ok
        ok
      HTML
    end

    it 'renders case-when' do
      assert_render(<<-'HAML', <<-HTML)
        - case 'foo'
        - when /\Ao/
          ng
        - when /\Af/
          ok
        - else
          ng
      HAML
        ok
      HTML
    end

    it 'renders case-when with multiple candidates' do
      assert_render(<<-'HAML', <<-HTML)
        - case 'a'
        - when 'a', 'b'
          ok
      HAML
        ok
      HTML
    end

    it 'renders begin-rescue' do
      assert_render(<<-'HAML', <<-HTML)
        - begin
          - raise 'error'
        - rescue
          hello
        - ensure
          world
      HAML
        hello
        world
      HTML
    end

    it 'renders rescue with error' do
      assert_render(<<-'HAML', <<-HTML)
        - begin
          - raise 'error'
        - rescue RuntimeError => e
          hello
      HAML
        hello
      HTML
    end

    it 'joins a next line if a current line ends with ","' do
      assert_render("- foo = [',  \n     ']\n= foo", <<-HTML, compatible_only: :haml)
        [&quot;, &quot;]
      HTML
    end

    it 'accepts illegal indent in continuing code' do
      assert_render(<<-HAML, <<-HTML)
        %span
          %div
            - def foo(a, b); a + b; end
            - num = foo(1,
        2)
            = num
      HAML
        <span>
        <div>
        3
        </div>
        </span>
      HTML
    end
  end
end
