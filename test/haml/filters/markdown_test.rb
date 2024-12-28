# frozen_string_literal: true

describe Haml::Filters do
  include RenderHelper

  describe '#compile' do
    it 'renders markdown filter' do
      if /java/ === RUBY_PLATFORM && !system('which pandoc > /dev/null')
        skip 'pandoc is required to test :markdown filter'
      end

      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <h1>Haml</h1>

        <p>Yet another haml implementation</p>

      HTML
        :markdown
          # Haml
          Yet another haml implementation
      HAML
    end

    it 'renders markdown filter with string interpolation' do
      if /java/ === RUBY_PLATFORM && !system('which pandoc > /dev/null')
        skip 'pandoc is required to test :markdown filter'
      end

      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <h1><Haml></h1>

        <p>&lt;&amp;&gt;
        Yet another haml implementation</p>

      HTML
        - project = '<Haml>'
        :markdown
          # #{project}
          #{'<&>'}
          Yet another haml implementation
      HAML
    end
  end
end
