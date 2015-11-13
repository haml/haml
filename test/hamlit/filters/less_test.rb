describe Hamlit::Filters do
  include RenderAssertion

  describe '#compile' do
    it 'renders less filter' do
      assert_render(<<-HAML, <<-HTML, compatible_only: :haml, error_with: :faml)
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
      assert_render(<<-'HAML', <<-HTML, compatible_only: :haml, error_with: :faml)
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
