describe Hamlit::Engine do
  describe 'HamlSyntaxError' do
    it 'raises on runtime' do
      code = Hamlit::Engine.new.call("  %a")
      assert_raises(Hamlit::HamlSyntaxError) do
        eval code
      end
    end

    it 'returns error with lines before error' do
      code = Hamlit::Engine.new.call("\n\n  %a")
      begin
        eval code
      rescue Hamlit::HamlSyntaxError => e
        assert_equal(2, e.line)
      end
    end
  end

  describe 'FilterNotFound' do
    it 'raises on runtime' do
      code = Hamlit::Engine.new.call(":k0kubun")
      assert_raises(Hamlit::FilterNotFound) do
        eval code
      end
    end

    it 'returns error with lines before error' do
      code = Hamlit::Engine.new.call("\n\n:k0kubun")
      begin
        eval code
      rescue Hamlit::FilterNotFound => e
        assert_equal(2, e.line)
      end
    end
  end
end
