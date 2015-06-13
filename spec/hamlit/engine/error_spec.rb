describe Hamlit::Engine do
  describe 'syntax error' do
    it 'raises syntax error for empty =' do
      expect { render_string('=  ') }.to raise_error(
        Hamlit::SyntaxError,
        "There's no Ruby code for = to evaluate.",
      )
    end

    it 'raises syntax error for illegal indentation' do
      expect { render_string(<<-HAML.unindent) }.
        %a
            %b
         %a
      HAML
        to raise_error(Hamlit::SyntaxError, 'Inconsistent indentation: 1 space used for indentation, but the rest of the document was indented using 4 spaces.')
    end

    it 'raises syntax error for illegal indentation' do
      expect { render_string(<<-HAML.unindent) }.
        %a
        \t\t%a
        \t%a
      HAML
        to raise_error(Hamlit::SyntaxError, 'Inconsistent indentation: 1 tab used for indentation, but the rest of the document was indented using 2 tabs.')
    end

    it 'raises syntax error which has correct line number in backtrace' do
      begin
        render_string(<<-HAML.unindent)
          %1
            %2
            %3
            %4
          %5
            %6
            %7
             %8 this is invalid indent
          %9
        HAML
      rescue Hamlit::SyntaxError => e
        if e.respond_to?(:backtrace_locations)
          line_number = e.backtrace_locations.first.to_s.match(/:(\d+):/)[1]
          expect(line_number).to eq('8')
        end
      end
    end

    it 'raises syntax error for an inconsistent indentation' do
      expect { render_string(<<-HAML.unindent) }.
        %a
          %b
        \t\t%b
      HAML
        to raise_error(Hamlit::SyntaxError, 'Inconsistent indentation: 2 tabs used for indentation, but the rest of the document was indented using 2 spaces.')
    end

    it 'raises syntax error for an inconsistent indentation' do
      expect { render_string(<<-'HAML'.unindent) }.
        1#{2
      HAML
        to raise_error(Hamlit::SyntaxError, 'Unbalanced brackets.')
    end

    it 'raises syntax error for an inconsistent indentation' do
      expect { render_string(<<-HAML.unindent) }.
        %p
        \t %span
      HAML
        to raise_error(Hamlit::SyntaxError, "Indentation can't use both tabs and spaces.")
    end

    it 'raises syntax error for an inconsistent indentation' do
      expect { render_string(<<-HAML.unindent) }.
        %div/ foo
      HAML
        to raise_error(Hamlit::SyntaxError, "Self-closing tags can't have content.")
    end

    it 'raises syntax error for an inconsistent indentation' do
      expect { render_string(<<-HAML.unindent) }.
        %div/
          foo
      HAML
        to raise_error(Hamlit::SyntaxError, "Illegal nesting: nesting within a self-closing tag is illegal.")
    end

    it 'rejects illegal indentation' do
      expect { render_string(<<-HAML.unindent) }.
        hello
          world
      HAML
        to raise_error(Hamlit::SyntaxError, 'Illegal nesting: nesting within plain text is illegal.')
    end

    it 'rejects illegal indentation' do
      expect { render_string(<<-HAML.unindent) }.
        %span hello
          world
      HAML
        to raise_error(Hamlit::SyntaxError, "Illegal nesting: content can't be both given on the same line as %span and nested within it.")
    end

    it 'rejects illegal indentation' do
      expect { render_string(<<-HAML.unindent) }.
        / hello
          world
      HAML
        to raise_error(Hamlit::SyntaxError, 'The line was indented 1 levels deeper than the previous line.')
    end

    it 'rejects illegal indentation' do
      expect { render_string(<<-HAML.unindent) }.
        %span
          %span
              %span
      HAML
        to raise_error(Hamlit::SyntaxError, 'The line was indented 2 levels deeper than the previous line.')
    end

    it 'rejects illegal indentation' do
      expect { render_string(<<-HAML.unindent) }.
        %span
            %span
              %span
      HAML
        to raise_error(Hamlit::SyntaxError, "Inconsistent indentation: 6 spaces used for indentation, but the rest of the document was indented using 4 spaces.")
    end

    it 'rejects illegal indentation' do
      expect { render_string('  hello') }.
        to raise_error(Hamlit::SyntaxError, 'Indenting at the beginning of the document is illegal.')
    end
  end
end
