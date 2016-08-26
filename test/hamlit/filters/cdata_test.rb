describe Hamlit::Filters do
  include RenderHelper

  describe '#compile' do
    it 'renders cdata' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <![CDATA[
          foo bar
        ]]>
      HTML
        :cdata
          foo bar
      HAML
    end

    it 'parses string interpolation' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <![CDATA[
          foo <&> bar
        ]]>
      HTML
        :cdata
          foo #{'<&>'} bar
      HAML
    end
  end
end
