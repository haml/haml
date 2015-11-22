describe Hamlit::HashParser do
  describe '.parse' do
    def assert_parse(expected, haml)
      actual = Hamlit::HashParser.parse(haml)
      assert_equal expected, actual
    end

    it { assert_parse({}, '') }
    it { assert_parse({}, '{}') }

    describe 'invalid hash' do
      it { assert_parse(nil, ' hash ') }
      it { assert_parse(nil, 'hash, foo: bar') }
      it { assert_parse(nil, ' {hash} ') }
      it { assert_parse(nil, ' { hash, foo: bar } ') }
    end

    describe 'dynamic key' do
      it { assert_parse(nil, 'foo => bar') }
      it { assert_parse(nil, '[] => bar') }
      it { assert_parse(nil, '[1,2,3] => bar') }
    end

    describe 'foo: bar' do
      it { assert_parse({ '_' => '1' }, '_:1,') }
      it { assert_parse({ 'foo' => 'bar' }, ' foo:  bar ') }
      it { assert_parse({ 'a' => 'b', 'c' => ':d' }, 'a: b, c: :d') }
      it { assert_parse({ 'a' => '[]', 'c' => '"d"' }, 'a: [], c: "d"') }
      it { assert_parse({ '_' => '1' }, ' { _:1, } ') }
      it { assert_parse({ 'foo' => 'bar' }, ' {  foo:  bar } ') }
      it { assert_parse({ 'a' => 'b', 'c' => ':d' }, ' { a: b, c: :d } ') }
      it { assert_parse({ 'a' => '[]', 'c' => '"d"' }, ' { a: [], c: "d" } ') }
    end

    describe ':foo => bar' do
      it { assert_parse({ 'foo' => ':bar' }, '  :foo   =>  :bar  ') }
      it { assert_parse({ '_' => '"foo"' }, ':_=>"foo"') }
      it { assert_parse({ 'a' => '[]', 'c' => '""', 'b' => '"#{3}"' }, ':a => [], c: "", :b => "#{3}"') }
      it { assert_parse({ 'foo' => ':bar' }, ' {   :foo   =>  :bar } ') }
      it { assert_parse({ '_' => '"foo"' }, ' { :_=>"foo" } ') }
      it { assert_parse({ 'a' => '[]', 'c' => '""', 'b' => '"#{3}"' }, ' { :a => [], c: "", :b => "#{3}" } ') }
      it { assert_parse(nil, ':"f#{o}o" => bar') }
      it { assert_parse(nil, ':"#{f}oo" => bar') }
      it { assert_parse(nil, ':"#{foo}" => bar') }
    end

    describe '"foo" => bar' do
      it { assert_parse({ 'foo' => '[1]' }, '"foo"=>[1]') }
      it { assert_parse({ 'foo' => 'nya' }, " 'foo' => nya ") }
      it { assert_parse({ 'foo' => 'bar' }, '%q[foo] => bar ') }
      it { assert_parse({ 'foo' => '[1]' }, ' { "foo"=>[1] } ') }
      it { assert_parse({ 'foo' => 'nya' }, " {  'foo' => nya } ") }
      it { assert_parse({ 'foo' => 'bar' }, ' { %q[foo] => bar } ') }
      it { assert_parse(nil, '"f#{o}o" => bar') }
      it { assert_parse(nil, '"#{f}oo" => bar') }
      it { assert_parse(nil, '"#{foo}" => bar') }
      it { assert_parse({ 'f#{o}o' => 'bar' }, '%q[f#{o}o] => bar ') }
      it { assert_parse({ 'f#{o}o' => 'bar' }, ' { %q[f#{o}o] => bar,  } ') }
      it { assert_parse(nil, '%Q[f#{o}o] => bar ') }
    end

    if RUBY_VERSION >= '2.1.0'
      describe '"foo": bar' do
        it { assert_parse({ 'foo' => '()' }, '"foo":()') }
        it { assert_parse({ 'foo' => 'nya' }, " 'foo': nya ") }
        it { assert_parse({ 'foo' => '()' }, ' { "foo":() , }') }
        it { assert_parse({ 'foo' => 'nya' }, " {  'foo': nya , }") }
        it { assert_parse(nil, '"f#{o}o": bar') }
        it { assert_parse(nil, '"#{f}oo": bar') }
        it { assert_parse(nil, '"#{foo}": bar') }
      end
    end

    describe 'nested array' do
      it { assert_parse({ 'foo' => '[1,2,]' }, 'foo: [1,2,],') }
      it { assert_parse({ 'foo' => '[1,2,[3,4],5]' }, 'foo: [1,2,[3,4],5],') }
      it { assert_parse({ 'foo' => '[1,2,[3,4],5]', 'bar' => '[[1,2],]'}, 'foo: [1,2,[3,4],5],bar: [[1,2],],') }
      it { assert_parse({ 'foo' => '[1,2,]' }, ' { foo: [1,2,], } ') }
      it { assert_parse({ 'foo' => '[1,2,[3,4],5]' }, ' { foo: [1,2,[3,4],5], } ') }
      it { assert_parse({ 'foo' => '[1,2,[3,4],5]', 'bar' => '[[1,2],]'}, ' { foo: [1,2,[3,4],5],bar: [[1,2],], } ') }
    end

    describe 'nested hash' do
      it { assert_parse({ 'foo' => '{ }', 'bar' => '{}' }, 'foo: { }, bar: {}') }
      it { assert_parse({ 'foo' => '{ bar: baz, hoge: fuga, }' }, 'foo: { bar: baz, hoge: fuga, }, ') }
      it { assert_parse({ 'data' => '{ confirm: true, disable: false }', 'hello' => '{ world: foo, }' }, 'data: { confirm: true, disable: false }, :hello => { world: foo, },') }
      it { assert_parse({ 'foo' => '{ }', 'bar' => '{}' }, ' { foo: { }, bar: {} } ') }
      it { assert_parse({ 'foo' => '{ bar: baz, hoge: fuga, }' }, ' { foo: { bar: baz, hoge: fuga, }, } ') }
      it { assert_parse({ 'data' => '{ confirm: true, disable: false }', 'hello' => '{ world: foo, }' }, ' { data: { confirm: true, disable: false }, :hello => { world: foo, }, } ') }
    end

    describe 'nested method' do
      it { assert_parse({ 'foo' => 'bar(a, b)', 'hoge' => 'piyo(a, b,)' }, 'foo: bar(a, b), hoge: piyo(a, b,),') }
      it { assert_parse({ 'foo' => 'bar(a, b)', 'hoge' => 'piyo(a, b,)' }, ' { foo: bar(a, b), hoge: piyo(a, b,), } ') }
    end
  end
end
