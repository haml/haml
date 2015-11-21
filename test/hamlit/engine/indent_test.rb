describe Hamlit::Engine do
  include RenderHelper

  describe 'tab indent' do
    it 'accepts tab indentation' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <p>
        <a></a>
        </p>
      HTML
        %p
        \t%a
      HAML
    end

    it 'accepts N-space indentation' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <p>
        <span>
        foo
        </span>
        </p>
      HTML
        %p
           %span
              foo
      HAML
    end

    it 'accepts N-tab indentation' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <p>
        <span>
        foo
        </span>
        </p>
      HTML
        %p
        \t%span
        \t\tfoo
      HAML
    end
  end
end
