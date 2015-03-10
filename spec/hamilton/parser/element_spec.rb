describe Hamilton::Parser do
  describe 'element' do
    it 'parses one-line element' do
      expect(parse_string('%span hello')).to eq(
        [:multi, [:html, :tag, 'span', [:html, :attrs], [:static, 'hello']]]
      )
    end
  end
end
