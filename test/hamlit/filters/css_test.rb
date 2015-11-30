describe Hamlit::Filters do
  include RenderHelper

  describe '#compile' do
    it 'renders css' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <style>
          .foo {
            width: 100px;
          }
        </style>
      HTML
        :css
          .foo {
            width: 100px;
          }
      HAML
    end

    it 'parses string interpolation' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <style>
          .foo {
            content: "<&>";
          }
        </style>
      HTML
        :css
          .foo {
            content: "#{'<&>'}";
          }
      HAML
    end
  end
end
