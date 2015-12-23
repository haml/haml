describe 'optimization' do
  def compiled_code(haml)
    Hamlit::Engine.new.call(haml)
  end

  describe 'static analysis' do
    it 'renders static value for href statically' do
      haml = %|%a{ href: 1 }|
      assert_equal true, compiled_code(haml).include?(%|href='1'|)
    end
  end
end
