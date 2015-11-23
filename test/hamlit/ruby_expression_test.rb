describe Hamlit::RubyExpression do
  describe '.syntax_error?' do
    it { assert_equal(true,  Hamlit::RubyExpression.syntax_error?('{ hash }')) }
    it { assert_equal(false, Hamlit::RubyExpression.syntax_error?('{ a: b }')) }
  end

  describe '.string_literal?' do
    def assert_literal(expected, code)
      actual = Hamlit::RubyExpression.string_literal?(code)
      assert_equal expected, actual
    end

    describe 'invalid expressions' do
      it { assert_literal(false, %q|{ hash }|) }
      it { assert_literal(false, %q|"hello".|) }
    end

    describe 'string literal' do
      it { assert_literal(true, %q|''|) }
      it { assert_literal(true, %q|""|) }
      it { assert_literal(true, %Q|'\n'|) }
      it { assert_literal(true, %q|'';   |) }
      it { assert_literal(true, %q|  ""  |) }
      it { assert_literal(true, %q|'hello world'|) }
      it { assert_literal(true, %q|"hello world"|) }
      it { assert_literal(true, %q|"h#{ %Q[e#{ "llo wor" }l] }d"|) }
      it { assert_literal(true, %q|%Q[nya]|) }
      it { assert_literal(true, %q|%Q[#{123}]|) }
    end

    describe 'not string literal' do
      it { assert_literal(false, %q|123|) }
      it { assert_literal(false, %q|'hello' + ''|) }
      it { assert_literal(false, %q|'hello'.to_s|) }
      it { assert_literal(false, %Q|'' \\ \n ''|) }
      it { assert_literal(false, %q|['']|) }
      it { assert_literal(false, %q|return ''|) }
    end

    describe 'multiple instructions' do
      it { assert_literal(false, %Q|''\n''|) }
    end
  end
end
