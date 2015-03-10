describe Hamilton::Engine do
  describe 'element' do
    it 'parses one-line element' do
      expect(render_string('%span hello')).to eq('<span>hello</span>')
    end
  end
end
