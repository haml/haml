describe Hamlit::Engine do
  describe 'runtime error' do
    it 'raises HamlSyntaxError on runtime' do
      code = Hamlit::Engine.new.call('  %a')
      assert_raises(Hamlit::HamlSyntaxError) do
        eval code
      end
    end
  end
end
