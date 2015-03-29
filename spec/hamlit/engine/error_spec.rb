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
      HAML
        to raise_error(Hamlit::SyntaxError, 'inconsistent indentation: 2 spaces used for indentation, but the rest of the document was indented using 4 spaces')
    end
  end
end
