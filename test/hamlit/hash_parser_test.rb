describe Hamlit::HashParser do
  describe '.parse' do
    def assert_parse(text, result)
      assert_equal result, Hamlit::HashParser.parse(text)
    end

    it 'parses static hash content' do
      assert_parse('', {})
    end

    it 'parses static hash content' do
      assert_parse(' foo:  bar ', { 'foo' => 'bar' })
    end

    it 'parses static hash content' do
      assert_parse('a: b, c: d', { 'a' => 'b', 'c' => 'd' })
    end
  end
end
