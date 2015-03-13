describe Hamlit::Parser::HashParser do
  describe '.parse' do
    it 'returns an empty hash for a text starting with whitespace' do
      line = ' '
      hash = {}
      expect(described_class.parse(line)).to eq(hash)
    end

    it 'parses an empty hash' do
      line = '{}'
      hash = {}
      expect(described_class.parse(line)).to eq(hash)
    end

    it 'parses a single-key hash' do
      hash = { 'foo' => '"bar"' }
      expect(described_class.parse('{foo:"bar"}')).to eq(hash)
      expect(described_class.parse('{ foo: "bar" }')).to eq(hash)
      expect(described_class.parse('{:foo=>"bar"}')).to eq(hash)
      expect(described_class.parse('{ :foo => "bar" }')).to eq(hash)
    end
  end
end
