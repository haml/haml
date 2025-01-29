# frozen_string_literal: true

describe Haml::Filters do
  include RenderHelper

  describe '#compile' do
    it 'renders coffee filter' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <script>
          (function() {
            var foo;
          
            foo = function() {
              return alert('hello');
            };
          
          }).call(this);
        </script>
      HTML
        :coffee
          foo = ->
            alert('hello')
      HAML
    end

    it 'renders coffeescript filter' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <script>
          (function() {
            var foo;
          
            foo = function() {
              return alert('hello');
            };
          
          }).call(this);
        </script>
      HTML
        :coffeescript
          foo = ->
            alert('hello')
      HAML
    end

    it 'renders coffeescript filter' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <script>
          (function() {
            var foo;
          
            foo = function() {
              return alert("<&>");
            };
          
          }).call(this);
        </script>
      HTML
        :coffee
          foo = ->
            alert("#{'<&>'}")
      HAML
    end
  end unless /java/ === RUBY_PLATFORM # execjs is not working with Travis JRuby environment
end
