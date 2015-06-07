describe Hamlit::Filters::Scss do
  describe '#compile' do
    it 'renders scss filter' do
      assert_render(<<-HAML, <<-HTML, compatible_only: :haml)
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
      assert_render(<<-'HAML', <<-HTML, compatible_only: :haml)
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
