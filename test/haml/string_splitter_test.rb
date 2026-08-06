# frozen_string_literal: true

describe Haml::StringSplitter do
  describe '.compile' do
    def assert_compile(expected, code)
      actual = Haml::StringSplitter.compile(code)
      assert_equal expected, actual
    end

    it { assert_compile([], %q|''|) }
    it { assert_compile([], %q|""|) }
    it { assert_compile([[:static, 'hello']], %q|"hello"|) }
    it { assert_compile([[:static, 'hello '], [:static, 'world']], %q|"hello #{}world"|) }
    it { assert_compile([[:dynamic, 'hello']], %q|"#{hello}"|) }
    it { assert_compile([[:static, 'nya'], [:dynamic, '123']], %q|"nya#{123}"|) }
    it { assert_compile([[:dynamic, '()'], [:static, '()']], %q|"#{()}()"|) }
    it { assert_compile([[:static, ' '], [:dynamic, %q[ " #{ '#{}' } " ]]], %q|" #{ " #{ '#{}' } " }"|) }
    it { assert_compile([[:static, 'a'], [:dynamic, 'b'], [:static, 'c'], [:dynamic, 'd'], [:static, 'e']], %q|%Q[a#{b}c#{d}e]|) }
    it { assert_compile([[:static, 'a#{b}c#{d}e']], %q|%q[a#{b}c#{d}e]|) }
    it { assert_compile([[:static, '#{}'], [:dynamic, '123']], %q|"\#{}#{123}"|) }
    it { assert_compile([[:dynamic, " '}' "]], %q|"#{ '}' }"|) }
    it { assert_compile([[:static, 'a']], %q| "a" # hello |) }
    it { assert_compile([[:static, '"']], %q|"\""|) }
    it { assert_compile([[:static, '\\"']], %q|"\\\\\\""|) }
    it { assert_compile([[:static, '\"']], %q|'\"'|) }
    it { assert_compile([[:static, '\"']], %q|'\\"'|) }
    it { assert_compile([[:static, '\\"']], %q|'\\\"'|) }

    describe 'paired delimiters' do
      it { assert_compile([[:static, 'a}b']], %q|%q{a\}b}|) }
      it { assert_compile([[:static, 'a)b']], %q|%q(a\)b)|) }
      it { assert_compile([[:static, 'a'], [:dynamic, 'b'], [:static, 'c']], %q|%Q{a#{b}c}|) }
      it { assert_compile([[:dynamic, ' {x: 1} ']], %q|%Q{#{ {x: 1} }}|) }
    end

    describe 'interpolated variable' do
      it { assert_compile([[:dynamic, '@foo']], %q|"#@foo"|) }
      it { assert_compile([[:dynamic, '$foo']], %q|"#$foo"|) }
      it { assert_compile([[:dynamic, '@@foo']], %q|"#@@foo"|) }
      it { assert_compile([[:static, 'a'], [:dynamic, '@foo'], [:static, ' b']], %q|"a#@foo b"|) }
    end

    describe 'heredoc' do
      it { assert_compile([[:static, "nya\n"]], %Q|<<~TEXT\n  nya\nTEXT|) }
    end

    # A template is compiled into a method body, so these are valid where they appear.
    describe 'jump keyword in interpolation' do
      it { assert_compile([[:dynamic, 'yield(:title)']], %q|"#{yield(:title)}"|) }
      it { assert_compile([[:static, 'a'], [:dynamic, 'next']], %q|"a#{next}"|) }
    end

    describe 'invalid argument' do
      def assert_internal_error(code)
        assert_raises Haml::InternalError do
          Haml::StringSplitter.compile(code)
        end
      end

      it { assert_internal_error(%q|1|) }
      it { assert_internal_error(%q|[]|) }
      it { assert_internal_error(%q|"]|) }
      it { assert_internal_error(%q|?a|) }
      it { assert_internal_error(%q|"a" "b"|) }
      it { assert_internal_error(%q|# comment|) }
    end

    describe '.try_compile' do
      it { assert_equal([[:static, 'nya']], Haml::StringSplitter.try_compile(%q|"nya"|)) }
      it { assert_nil(Haml::StringSplitter.try_compile(%q|"#{1 +}"|)) }
      it { assert_nil(Haml::StringSplitter.try_compile(%q|1|)) }
    end
  end
end
