describe Hamlit::Filters do
  include RenderHelper

  describe '#compile' do
    it 'renders sass filter' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <style>
          .users_controller .show_action {
            margin: 10px;
            padding: 20px; }
        </style>
      HTML
        :sass
          .users_controller
            .show_action
              margin: 10px
              padding: 20px
      HAML
    end

    it 'renders sass filter with string interpolation' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <style>
          .users_controller .show_action {
            content: "<&>"; }
        </style>
      HTML
        :sass
          .users_controller
            .show_action
              content: "#{'<&>'}"
      HAML
    end
  end
end
