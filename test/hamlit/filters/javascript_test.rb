describe Hamlit::Filters do
  include RenderHelper

  describe '#compile' do
    it 'just renders script tag for empty filter' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        before
        <script>
          
        </script>
        after
      HTML
        before
        :javascript
        after
      HAML
    end

    it 'compiles javascript filter' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        before
        <script>
          alert('hello');
        </script>
        after
      HTML
        before
        :javascript
          alert('hello');
        after
      HAML
    end

    it 'accepts illegal indentation' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <script>
          if {
           alert('hello');
            }
        </script>
        <script>
            if {
             alert('hello');
              }
        </script>
      HTML
        :javascript
         if {
          alert('hello');
           }
        :javascript
           if {
            alert('hello');
             }
      HAML
    end

    it 'accepts illegal indentation' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <script>
          if {
           alert('a');
          }
        </script>
      HTML
        :javascript
           if {
            alert('a');
           }
      HAML
    end

    it 'parses string interpolation' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <script>
          var a = "<&>";
        </script>
      HTML
        :javascript
          var a = "#{'<&>'}";
      HAML
    end
  end
end
