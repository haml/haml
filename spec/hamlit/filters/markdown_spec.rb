describe Hamlit::Filters::Markdown do
  describe '#compile' do
    it 'renders markdown filter' do
      assert_render(<<-HAML, <<-HTML)
        :markdown
          # Hamlit
          Yet another haml implementation
      HAML
        <h1>Hamlit</h1>

        <p>Yet another haml implementation</p>
      HTML
    end

    it 'renders markdown filter with string interpolation' do
      assert_render(<<-'HAML', <<-HTML, compatible_with: :faml)
        - project = '<Hamlit>'
        :markdown
          # #{project}
          #{'<&>'}
          Yet another haml implementation
      HAML
        <h1><Hamlit></h1>

        <p>&lt;&amp;&gt;
        Yet another haml implementation</p>
      HTML
    end
  end
end
