describe Hamlit::Filters::Erb do
  describe '#compile' do
    it 'renders erb filter' do
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
