describe Hamlit::StaticAnalyzer do
  describe '.static?' do
    def assert_static(expected, ruby_exp)
      actual = Hamlit::StaticAnalyzer.static?(ruby_exp)
      assert_equal expected, actual
    end

    describe 'static expression' do
      it { assert_static(true, 'true') }
      it { assert_static(true, 'false') }
      it { assert_static(true, 'nil') }
      it { assert_static(true, '()') }
      it { assert_static(true, '(nil)') }
      it { assert_static(true, '[true, false, nil, (true)]') }
      it { assert_static(true, '3') }
      it { assert_static(true, '1.2') }
      it { assert_static(true, '2i') }
      it { assert_static(true, '[3, 1.2, [2i, "hello #{ 123 } world"]]') }
      it { assert_static(true, '(3)') }
      it { assert_static(true, '""') }
      it { assert_static(true, '"hello world"') }
      it { assert_static(true, '"a#{}b"') }
      it { assert_static(true, '{}') }
      it { assert_static(true, '{ "key" => "value" }') }
      it { assert_static(true, '{ key: "value" }') }
    end

    describe 'dynamic expression' do
      it { assert_static(false, 'if true') }
      it { assert_static(false, 'foo') }
      it { assert_static(false, '"hello #{ world }"') }
      it { assert_static(false, '"" + bar') }
      it { assert_static(false, '"" ** bar') }
      it { assert_static(false, '"".gsub(/foo/, "bar")') }
      it { assert_static(false, '"".freeze') }
      it { assert_static(false, '1.times {}') }
      it { assert_static(false, '[3, 1.2, [2i, "hello #{ nya } world"]]') }
      it { assert_static(false, 'self') }
      it { assert_static(false, '__FILE__') }
      it { assert_static(false, '__LINE__') }
      it { assert_static(false, '__ENCODING__') }
      it { assert_static(false, '__dir__') }
    end

    describe 'invalid expression' do
      it { assert_static(false, nil) }
      it { assert_static(false, ' ') }
      it { assert_static(false, '}') }
      it { assert_static(false, '(') }
      it { assert_static(false, '+') }
    end
  end
end
