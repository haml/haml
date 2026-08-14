# frozen_string_literal: true

describe Haml::AttributeParser do
  describe '.parse' do
    def assert_parse(expected, haml)
      actual = Haml::AttributeParser.parse(haml)
      if expected.nil?
        assert_nil actual
      else
        assert_equal expected, actual
      end
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

    describe '"foo": bar' do
      it { assert_parse({ 'foo' => '()' }, '"foo":()') }
      it { assert_parse({ 'foo' => 'nya' }, " 'foo': nya ") }
      it { assert_parse({ 'foo' => '()' }, ' { "foo":() , }') }
      it { assert_parse({ 'foo' => 'nya' }, " {  'foo': nya , }") }
      it { assert_parse(nil, '"f#{o}o": bar') }
      it { assert_parse(nil, '"#{f}oo": bar') }
      it { assert_parse(nil, '"#{foo}": bar') }
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

    describe 'splat' do
      it { assert_parse(nil, '**foo') }
      it { assert_parse(nil, 'foo: bar, **baz') }
    end

    describe 'value omission' do
      it { assert_parse({ 'foo' => '' }, 'foo:') }
      it { assert_parse({ 'foo' => '', 'bar' => '1' }, 'foo:, bar: 1') }
    end

    describe 'escape in key' do
      # The key reaches the attribute name as the source spelled it, unescaped.
      it { assert_parse({ 'a\0b' => '1' }, '"a\0b" => 1') }
      it { assert_parse({ 'a\tb' => '1' }, '"a\tb" => 1') }
      it { assert_parse({ 'a b' => '1' }, ':"a b" => 1') }
    end

    # Prism re-tags its slices with the encoding it parsed under (UTF-8 for a BINARY
    # source), but keys and values must stay in the source encoding: the compiled
    # template joins them with fragments sliced out of the source itself, and mixed
    # encodings raise Encoding::CompatibilityError. See haml/haml#1218.
    describe 'binary source' do
      it 'keeps keys and values in the source encoding' do
        hash = Haml::AttributeParser.parse(%q|title: '🍣', '🍺' => beer|.b)
        assert_equal({ 'title'.b => %q|'🍣'|.b, '🍺'.b => 'beer'.b }, hash)
        (hash.keys + hash.values).each do |string|
          assert_equal Encoding::BINARY, string.encoding
        end
      end
    end

    # A multi-line hash is deliberately left to the runtime: compiling it statically drops a
    # [:newline] and shifts every __LINE__ after it. See test/haml/line_number_test.rb.
    describe 'multiline' do
      it { assert_parse(nil, "foo: 1,\n  bar: 2") }
      it { assert_parse(nil, " { foo: 1,\n  bar: 2 } ") }
    end
  end

  describe '.available?' do
    it { assert_equal(true, Haml::AttributeParser.available?) }
  end
end
