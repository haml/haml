describe Haml::Engine do
  describe 'Error' do
    it 'raises an error when Haml::Parser is used independently' do
      assert_raises(Haml::Error) do
        Haml::Parser.new({}).call("%body\n  %div\n        %p")
      end
    end
  end

  describe 'SyntaxError' do
    it 'raises on runtime' do
      code = Haml::Engine.new.call("  %a")
      assert_raises(Haml::SyntaxError) do
        eval code
      end
    end

    it 'returns error with lines before error' do
      code = Haml::Engine.new.call("\n\n  %a")
      begin
        eval code
      rescue Haml::SyntaxError => e
        assert_equal(2, e.line)
      end
    end

    describe 'Haml v1 syntax' do
      it 'returns an error with proper line number' do
        code = Haml::Engine.new.call(<<-HAML.unindent)
          %span
          - if true
            %div{ data: {
              hello: 'world',
            } }
        HAML
        begin
          eval code
        rescue Haml::SyntaxError => e
          assert_equal(3, e.line)
        end
      end
    end
  end

  describe 'FilterNotFound' do
    it 'raises on runtime' do
      code = Haml::Engine.new.call(":k0kubun")
      assert_raises(Haml::FilterNotFound) do
        eval code
      end
    end

    it 'returns error with lines before error' do
      code = Haml::Engine.new.call("\n\n:k0kubun")
      begin
        eval code
      rescue Haml::FilterNotFound => e
        assert_equal(2, e.line)
      end
    end
  end
end
