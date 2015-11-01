describe Hamlit::HashParser do
  describe '.parse' do
    def assert_parse(text, result)
      assert_equal result, Hamlit::HashParser.parse(text)
    end

    it 'returns nil for invalid expression' do
      assert_parse(' hash ', nil)
    end

    it 'returns nil for partially valid expression' do
      assert_parse('hash, foo: bar', nil)
    end

    it 'parses static hash content' do
      assert_parse('', {})
    end

    describe 'foo: bar' do
      it 'parses static hash content' do
        assert_parse('_:1,', { '_' => '1' })
      end

      it 'parses static hash content' do
        assert_parse(' foo:  bar ', { 'foo' => 'bar' })
      end

      it 'parses static hash content' do
        assert_parse('a: b, c: :d', { 'a' => 'b', 'c' => ':d' })
      end

      it 'parses static hash content' do
        assert_parse('a: [], c: "d"', { 'a' => '[]', 'c' => '"d"' })
      end
    end

    describe ':foo => bar' do
      it 'parses static hash content' do
        assert_parse('  :foo   =>  :bar  ', { 'foo' => ':bar' })
      end

      it 'parses static hash content' do
        assert_parse(':_=>"foo"', { '_' => '"foo"' })
      end

      it 'parses static hash content' do
        assert_parse(':a => [], c: "", :b => "#{3}"', { 'a' => '[]', 'c' => '""', 'b' => '"#{3}"' })
      end
    end
  end
end
