describe Hamlit::Filters do
  include RenderAssertion

  describe '#compile' do
    it 'renders scss filter' do
      skip
      assert_render(<<-HAML, <<-HTML)
        :scss
          .users_controller {
            .show_action {
              margin: 10px;
              padding: 20px;
            }
          }
      HAML
        <style>
          .users_controller .show_action {
            margin: 10px;
            padding: 20px; }
        </style>
      HTML
    end

    it 'parses string interpolation' do
      skip
      assert_render(<<-'HAML', <<-HTML)
        :scss
          .users_controller {
            .show_action {
              content: "#{'<&>'}";
            }
          }
      HAML
        <style>
          .users_controller .show_action {
            content: "<&>"; }
        </style>
      HTML
    end
  end
end
