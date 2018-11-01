describe Hamlit::StringSplitter do
  describe '.compile' do
    def assert_compile(expected, code)
      actual = Hamlit::StringSplitter.compile(code)
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

    describe 'invalid argument' do
      it 'raises internal error' do
        assert_raises Hamlit::InternalError do
          Hamlit::StringSplitter.compile('1')
        end
      end

      it 'raises internal error' do
        assert_raises Hamlit::InternalError do
          Hamlit::StringSplitter.compile('[]')
        end
      end

      it 'raises internal error' do
        if /java/ === RUBY_PLATFORM
          skip 'Ripper of JRuby is behaving in a different way'
        end

        assert_raises Hamlit::InternalError do
          Hamlit::StringSplitter.compile('"]')
        end
      end
    end
  end
end
