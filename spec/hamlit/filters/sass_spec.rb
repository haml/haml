describe Hamlit::Filters::Sass do
  describe '#compile' do
    it 'renders sass filter' do
      assert_render(<<-HAML, <<-HTML)
        :sass
          .users_controller
            .show_action
              margin: 10px
              padding: 20px
      HAML
        <style>
          .users_controller .show_action {
            margin: 10px;
            padding: 20px; }
        </style>
      HTML
    end
  end
end
