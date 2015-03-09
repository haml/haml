describe Hamilton::Parser do
  describe 'doctype' do
    it 'parses html5 doctype' do
      expect(parse_string('!!!')).to eq([:multi, [:html, :doctype, 'html']])
    end
  end
end
