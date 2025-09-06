# frozen_string_literal: true

describe Haml::Helpers do
  describe '.preserve' do
    it 'works without block' do
      result = Haml::Helpers.preserve("hello\nworld")
      assert_equal 'hello&#x000A;world', result
    end
  end
end
