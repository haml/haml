describe Hamlit::Engine do
  describe 'syntax error' do
    it 'raises syntax error for empty =' do
      expect { render_string('=  ') }.to raise_error(
        Hamlit::SyntaxError,
        "There's no Ruby code for = to evaluate.",
      )
    end
  end
end
