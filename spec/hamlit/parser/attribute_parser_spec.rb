describe Hamlit::Parser::AttributeParser do
  describe '.parse' do
    def assert_hash(string, hash)
      s = StringScanner.new(string)
      expect(described_class.parse(s)).to eq(hash)
    end

    it 'returns an empty hash for a text starting with whitespace' do
      assert_hash(' ', {})
    end

    it 'parses an empty hash' do
      assert_hash(' ', {})
    end

    it 'parses a single-key hash' do
      assert_hash('{foo:"bar"}', { 'foo' => '"bar"' })
      assert_hash('{ foo: "bar" }', { 'foo' => '"bar"' })
      assert_hash('{ foo: 2 }', { 'foo' => '2' })
      assert_hash('{ :foo => 2 }', { 'foo' => '2' })
    end

    it 'parses a string-key hash' do
      assert_hash(%!{ 'a' => 1 }!, { 'a' => '1' })
      assert_hash(%!{ "foo" => 'bar' }!, { 'foo' => "'bar'" })
    end

    it 'parses a nested hash' do
      assert_hash('{ a: { b: 1 } }', { 'a' => { 'b' => '1' } })
      assert_hash(
        '{ a: { b: 1, c: 2 }, d: 3, e: {} }',
        { 'a' => { 'b' => '1', 'c' => '2' }, 'd' => '3', 'e' => {} },
      )
    end

    it 'parses a quoted-symbol-key hash' do
      assert_hash(%!{ :"data-disable" => true }!, { 'data-disable' => 'true' })
      assert_hash(%!{ :'data-disable' => true }!, { 'data-disable' => 'true' })
    end

    it 'parses a multiple-keys hash' do
      assert_hash('{a:"b",c:"d#{e}"}', { 'a' => '"b"', 'c' => '"d#{e}"' })
      assert_hash('{ a: 2, :b => ","}', { 'a' => '2', 'b' => '","' })
    end

    describe 'scanner position' do
      it 'scans balanced hash' do
        line = '{ a: 1, b: { c: 4 } }='
        s = StringScanner.new(line)
        described_class.parse(s)
        expect(s.peek(1)).to eq('=')
      end

      it 'scans balanced hash from internal position' do
        line = "%span{class: 'foo'} bar"
        s = StringScanner.new(line)
        s.scan(/%span/)
        described_class.parse(s)
        expect(s.peek(1)).to eq(' ')
      end
    end
  end

  describe '.flat_parse' do
    def assert_flat_hash(string, hash)
      s = StringScanner.new(string)
      expect(described_class.flat_parse(s)).to eq(hash)
    end

    it 'parses deep hash flatly' do
      assert_flat_hash(
        '{ a: 1, b: { c: 3 } }',
        { 'a' => '1', 'b-c' => '3' },
      )
    end

    it 'parses deep hash flatly and drops empty hash value' do
      assert_flat_hash(
        '{ a: { b: {}, c: { d: "e" }, f: "g" } }',
        { 'a-c-d' => '"e"', 'a-f' => '"g"' },
      )
    end
  end
end
