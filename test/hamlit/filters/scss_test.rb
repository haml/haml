describe Hamlit::Filters do
  include RenderHelper

  describe '#compile' do
    it 'renders scss filter' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <style>
          .users_controller .show_action {
            margin: 10px;
            padding: 20px; }
        </style>
      HTML
        :scss
          .users_controller {
            .show_action {
              margin: 10px;
              padding: 20px;
            }
          }
      HAML
    end

    it 'parses string interpolation' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <style>
          .users_controller .show_action {
            content: "<&>"; }
        </style>
      HTML
        :scss
          .users_controller {
            .show_action {
              content: "#{'<&>'}";
            }
          }
      HAML
    end
  end
end
