describe Hamlit::Engine do
  describe 'tab indent' do
    it 'accepts tab indentation' do
      assert_render(<<-HAML, <<-HTML, compatible_only: :haml, error_with: :faml)
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
      assert_render(<<-HAML, <<-HTML, compatible_only: :haml, error_with: :faml)
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
