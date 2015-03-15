describe Hamlit::MultilinePreprocessor do
  describe '#call' do
    it 'does not alter normal lines' do
      assert_compile(<<-HAML, <<-HAML)
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
      assert_compile(<<-HAML, <<-HAML)
        abc  |
        d    |
        ef
      HAML
        abc d

        ef
      HAML
    end

    it 'joins multi-lines' do
      assert_compile(<<-HAML, <<-HAML)
        = 'a' + |
            'b' |
      HAML
        = 'a' + 'b'

      HAML
    end
  end
end
