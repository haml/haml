describe Hamlit::AttributeCompiler do
  def assert_compile(before, after)
    result = described_class.new.call(before)
    expect(result).to eq(after)
  end

  describe '#call' do
    it 'does not alter normal attrs' do
      assert_compile(
        [:html,
         :attrs,
         [:html, :attr, 'id', [:static, 'foo']],
         [:html, :attr, 'class', [:static, 'bar']]],
        [:html,
         :attrs,
         [:html, :attr, 'id', [:static, 'foo']],
         [:html, :attr, 'class', [:static, 'bar']]],
      )
    end

    it 'convers only string' do
      assert_compile(
        [:html,
         :attrs,
         [:html, :attr, 'id', [:static, 'foo']],
         '{ foo: "bar" }',
         [:html, :attr, 'class', [:static, 'bar']]],
        [:html,
         :attrs,
         [:html, :attr, 'id', [:static, 'foo']],
         [:html, :attr, 'foo', [:dynamic, '"bar"']],
         [:html, :attr, 'class', [:static, 'bar']]],
      )
    end

    it 'converts nested attributes' do
      assert_compile(
        [:html,
         :attrs,
         '{ a: { b: {}, c: "d" }, e: "f" }'],
        [:html,
         :attrs,
         [:html, :attr, 'a-c', [:dynamic, '"d"']],
         [:html, :attr, 'e', [:dynamic, '"f"']]],
      )
    end
  end
end
