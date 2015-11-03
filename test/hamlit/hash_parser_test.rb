describe Hamlit::HashParser do
  describe '.parse' do
    def assert_parse(text, result)
      assert_equal result, Hamlit::HashParser.parse(text)
    end

    it { assert_parse('', {}) }

    describe 'invalid hash' do
      it { assert_parse(' hash ', nil) }
      it { assert_parse('hash, foo: bar', nil) }
    end

    describe 'dynamic key' do
      it { assert_parse('foo => bar', nil) }
      it { assert_parse('[] => bar', nil) }
      it { assert_parse('[1,2,3] => bar', nil) }
    end

    describe 'foo: bar' do
      it { assert_parse('_:1,', { '_' => '1' }) }
      it { assert_parse(' foo:  bar ', { 'foo' => 'bar' }) }
      it { assert_parse('a: b, c: :d', { 'a' => 'b', 'c' => ':d' }) }
      it { assert_parse('a: [], c: "d"', { 'a' => '[]', 'c' => '"d"' }) }
    end

    describe ':foo => bar' do
      it { assert_parse('  :foo   =>  :bar  ', { 'foo' => ':bar' }) }
      it { assert_parse(':_=>"foo"', { '_' => '"foo"' }) }
      it { assert_parse(':a => [], c: "", :b => "#{3}"', { 'a' => '[]', 'c' => '""', 'b' => '"#{3}"' }) }
      it { assert_parse(':"f#{o}o" => bar', nil) }
      it { assert_parse(':"#{f}oo" => bar', nil) }
      it { assert_parse(':"#{foo}" => bar', nil) }
    end

    describe '"foo" => bar' do
      it { assert_parse('"foo"=>[1]', { 'foo' => '[1]' }) }
      it { assert_parse(" 'foo' => nya ", { 'foo' => 'nya' }) }
      it { assert_parse('%q[foo] => bar ', { 'foo' => 'bar' }) }
      it { assert_parse('"f#{o}o" => bar', nil) }
      it { assert_parse('"#{f}oo" => bar', nil) }
      it { assert_parse('"#{foo}" => bar', nil) }
      it { assert_parse('%q[f#{o}o] => bar ', { 'f#{o}o' => 'bar' }) }
      it { assert_parse('%Q[f#{o}o] => bar ', nil) }
    end

    if RUBY_VERSION >= '2.1.0'
      describe '"foo" => bar' do
        it { assert_parse('"foo":()', { 'foo' => '()' }) }
        it { assert_parse(" 'foo': nya ", { 'foo' => 'nya' }) }
        it { assert_parse('"f#{o}o": bar', nil) }
        it { assert_parse('"#{f}oo": bar', nil) }
        it { assert_parse('"#{foo}": bar', nil) }
      end
    end

    describe 'nested array' do
      it { assert_parse('foo: [1,2,],', { 'foo' => '[1,2,]' }) }
      it { assert_parse('foo: [1,2,[3,4],5],', { 'foo' => '[1,2,[3,4],5]' }) }
      it { assert_parse('foo: [1,2,[3,4],5],bar: [[1,2],],', { 'foo' => '[1,2,[3,4],5]', 'bar' => '[[1,2],]'}) }
    end

    describe 'nested hash' do
      it { assert_parse('foo: { }, bar: {}', { 'foo' => '{ }', 'bar' => '{}' }) }
      it { assert_parse('foo: { bar: baz, hoge: fuga, }, ', { 'foo' => '{ bar: baz, hoge: fuga, }' }) }
      it { assert_parse('data: { confirm: true, disable: false }, :hello => { world: foo, },', { 'data' => '{ confirm: true, disable: false }', 'hello' => '{ world: foo, }' }) }
    end
  end
end
