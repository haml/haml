describe Hamlit::StaticAnalyzer do
  describe '.static?' do
    def assert_static(exp, result)
      assert_equal result, Hamlit::StaticAnalyzer.static?(exp)
    end

    specify 'static expression' do
      assert_static('true', true)
      assert_static('false', true)
      assert_static('nil', true)
      assert_static('()', true)
      assert_static('(nil)', true)
      assert_static('[true, false, nil, (true)]', true)
      assert_static('3', true)
      assert_static('1.2', true)
      assert_static('2i', true)
      assert_static('[3, 1.2, [2i, "hello #{ 123 } world"]]', true)
      assert_static('(3)', true)
      assert_static('""', true)
      assert_static('"hello world"', true)
      assert_static('"a#{}b"', true)
      assert_static('{}', true)
      assert_static('{ "key" => "value" }', true)
      assert_static('{ key: "value" }', true)
    end

    specify 'dynamic expression' do
      assert_static('if true', false)
      assert_static('foo', false)
      assert_static('"hello #{ world }"', false)
      assert_static('"" + bar', false)
      assert_static('"" ** bar', false)
      assert_static('"".gsub(/foo/, "bar")', false)
      assert_static('1.times {}', false)
      assert_static('[3, 1.2, [2i, "hello #{ nya } world"]]', false)
      assert_static('self', false)
      assert_static('__FILE__', false)
      assert_static('__LINE__', false)
      assert_static('__ENCODING__', false)
      assert_static('__dir__', false)
    end

    specify 'invalid expression' do
      assert_static(nil, false)
      assert_static(' ', false)
      assert_static('}', false)
      assert_static('(', false)
      assert_static('+', false)
    end
  end
end
