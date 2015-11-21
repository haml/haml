describe Hamlit::StaticAnalyzer do
  describe '.static?' do
    def assert_static(expected, ruby_exp)
      actual = Hamlit::StaticAnalyzer.static?(ruby_exp)
      assert_equal expected, actual
    end

    specify 'static expression' do
      assert_static(true, 'true')
      assert_static(true, 'false')
      assert_static(true, 'nil')
      assert_static(true, '()')
      assert_static(true, '(nil)')
      assert_static(true, '[true, false, nil, (true)]')
      assert_static(true, '3')
      assert_static(true, '1.2')
      assert_static(true, '2i')
      assert_static(true, '[3, 1.2, [2i, "hello #{ 123 } world"]]')
      assert_static(true, '(3)')
      assert_static(true, '""')
      assert_static(true, '"hello world"')
      assert_static(true, '"a#{}b"')
      assert_static(true, '{}')
      assert_static(true, '{ "key" => "value" }')
      assert_static(true, '{ key: "value" }')
    end

    specify 'dynamic expression' do
      assert_static(false, 'if true')
      assert_static(false, 'foo')
      assert_static(false, '"hello #{ world }"')
      assert_static(false, '"" + bar')
      assert_static(false, '"" ** bar')
      assert_static(false, '"".gsub(/foo/, "bar")')
      assert_static(false, '1.times {}')
      assert_static(false, '[3, 1.2, [2i, "hello #{ nya } world"]]')
      assert_static(false, 'self')
      assert_static(false, '__FILE__')
      assert_static(false, '__LINE__')
      assert_static(false, '__ENCODING__')
      assert_static(false, '__dir__')
    end

    specify 'invalid expression' do
      assert_static(false, nil)
      assert_static(false, ' ')
      assert_static(false, '}')
      assert_static(false, '(')
      assert_static(false, '+')
    end
  end
end
