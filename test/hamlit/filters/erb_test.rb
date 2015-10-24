describe Hamlit::Filters do
  include RenderAssertion

  describe '#compile' do
    it 'renders erb filter' do
      skip
      assert_render(<<-HAML, <<-HTML, compatible_only: [], error_with: :faml)
        :erb
          <% if true %>
          ok
          <% else %>
          ng
          <% end %>
      HAML
        ok
      HTML
    end
  end
end
