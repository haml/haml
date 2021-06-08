describe Hamlit::Helpers do
  describe '.preserve' do
    it 'works without block' do
      result = Hamlit::Helpers.preserve("hello\nworld")
      assert_equal 'hello&#x000A;world', result
    end
  end
end
