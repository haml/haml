# frozen_string_literal: true

describe Haml::Helpers do
  describe '.preserve' do
    it 'works without block' do
      result = Haml::Helpers.preserve("hello\nworld")
      assert_equal 'hello&#x000A;world', result
    end

    it 'chomps a single trailing newline' do
      assert_equal 'a&#x000A;', Haml::Helpers.preserve("a\n\n")
      assert_equal 'a&#x000A;b', Haml::Helpers.preserve("a\nb\n")
      assert_equal 'no newline', Haml::Helpers.preserve('no newline')
    end

    it 'deletes carriage returns' do
      assert_equal 'a&#x000A;b', Haml::Helpers.preserve("a\r\nb")
      assert_equal 'ab', Haml::Helpers.preserve("a\rb")
    end

    it 'converts whatever it is given to a String' do
      assert_equal '13', Haml::Helpers.preserve(13)
      assert_equal '', Haml::Helpers.preserve(nil)
      assert_equal 'a&#x000A;b', Haml::Helpers.preserve("a\nb".html_safe)
    end

    it 'still rejects a broken byte sequence' do
      # gsub! with a String pattern would substitute where the Regexp raised, but delete!
      # on the next line raises the same error, so the method is unchanged end to end.
      broken = (+"a\xFFb\nc").force_encoding('UTF-8')
      error = assert_raises(ArgumentError) { Haml::Helpers.preserve(broken) }
      assert_equal 'invalid byte sequence in UTF-8', error.message
    end
  end
end
