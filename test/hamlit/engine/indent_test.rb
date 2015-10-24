describe Hamlit::Engine do
  include RenderAssertion

  describe 'tab indent' do
    it 'accepts tab indentation' do
      assert_render(<<-HAML, <<-HTML)
        %p
        \t%a
      HAML
        <p>
        <a></a>
        </p>
      HTML
    end

    it 'accepts N-space indentation' do
      assert_render(<<-HAML, <<-HTML)
        %p
           %span
              foo
      HAML
        <p>
        <span>
        foo
        </span>
        </p>
      HTML
    end

    it 'accepts N-tab indentation' do
      assert_render(<<-HAML, <<-HTML)
        %p
        \t%span
        \t\tfoo
      HAML
        <p>
        <span>
        foo
        </span>
        </p>
      HTML
    end
  end
end
