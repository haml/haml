describe Hamlit::Filters::Javascript do
  describe '#compile' do
    it 'just renders script tag for empty filter' do
      assert_render(<<-HAML, <<-HTML)
        before
        :javascript
        after
      HAML
        before
        <script>

        </script>
        after
      HTML
    end

    it 'compiles javascript filter' do
      assert_render(<<-HAML, <<-HTML)
        before
        :javascript
          alert('hello');
        after
      HAML
        before
        <script>
          alert('hello');
        </script>
        after
      HTML
    end

    it 'accepts illegal indentation' do
      assert_render(<<-HAML, <<-HTML)
        :javascript
         if {
          alert('hello');
           }
        :javascript
           if {
            alert('hello');
             }
      HAML
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
    end

    it 'accepts illegal indentation' do
      assert_render(<<-HAML, <<-HTML)
        :javascript
           if {
            alert('a');
           }
      HAML
        <script>
          if {
           alert('a');
          }
        </script>
      HTML
    end

    it 'parses string interpolation' do
      assert_render(<<-'HAML', <<-HTML)
        :javascript
          var a = "#{'<&>'}";
      HAML
        <script>
          var a = "<&>";
        </script>
      HTML
    end
  end
end
