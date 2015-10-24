describe Hamlit::Filters do
  include RenderAssertion

  describe '#compile' do
    it 'renders coffee filter' do
      skip
      assert_render(<<-HAML, <<-HTML)
        :coffee
          foo = ->
            alert('hello')
      HAML
        <script>
          (function() {
            var foo;
          
            foo = function() {
              return alert('hello');
            };
          
          }).call(this);
        </script>
      HTML
    end

    it 'renders coffeescript filter' do
      skip
      assert_render(<<-HAML, <<-HTML)
        :coffee
          foo = ->
            alert('hello')
      HAML
        <script>
          (function() {
            var foo;
          
            foo = function() {
              return alert('hello');
            };
          
          }).call(this);
        </script>
      HTML
    end

    it 'renders coffeescript filter' do
      skip
      assert_render(<<-'HAML', <<-HTML)
        :coffee
          foo = ->
            alert("#{'<&>'}")
      HAML
        <script>
          (function() {
            var foo;
          
            foo = function() {
              return alert("<&>");
            };
          
          }).call(this);
        </script>
      HTML
    end
  end
end
