describe Hamlit::Filters do
  include RenderHelper

  describe '#compile' do
    it 'renders erb filter' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        ok

      HTML
        :erb
          <% if true %>
          ok
          <% else %>
          ng
          <% end %>
      HAML
    end
  end
end
