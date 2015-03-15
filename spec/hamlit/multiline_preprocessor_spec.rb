describe Hamlit::MultilinePreprocessor do
  describe '#call' do
    def assert_multiline_preprocess(before, after)
      result = described_class.new.call(before)
      expect(result).to eq(after)
    end

    it 'does not alter normal lines' do
      assert_multiline_preprocess(<<-HAML, <<-HAML)
        abc
        d|
        ef
      HAML
        abc
        d|
        ef
      HAML
    end

    it 'joins multi-lines' do
      assert_multiline_preprocess(<<-HAML, <<-HAML)
        abc  |
        d    |
        ef
      HAML
        abc d

        ef
      HAML
    end

    it 'joins multi-lines' do
      assert_multiline_preprocess(<<-HAML, <<-HAML)
        = 'a' + |
            'b' |
      HAML
        = 'a' + 'b'

      HAML
    end
  end
end
