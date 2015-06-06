describe Hamlit::Filters::Less do
  describe '#compile' do
    it 'renders less filter' do
      assert_render(<<-HAML, <<-HTML)
        :less
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
            padding: 20px;
          }
        </style>
      HTML
    end

    it 'parses string interpolation' do
      assert_render(<<-'HAML', <<-HTML)
        :less
          .foo {
            content: "#{'<&>'}";
          }
      HAML
        <style>
          .foo {
            content: "<&>";
          }
        </style>
      HTML
    end
  end
end
