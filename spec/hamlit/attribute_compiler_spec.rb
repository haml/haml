describe Hamlit::AttributeCompiler do
  describe '#call' do
    it 'does not alter normal attrs' do
      assert_compile(
        [:haml,
         :attrs,
         [:html, :attr, 'id', [:static, 'foo']],
         [:html, :attr, 'class', [:static, 'bar']]],
        [:haml,
         :attrs,
         [:html, :attr, 'id', [:static, 'foo']],
         [:html, :attr, 'class', [:static, 'bar']]],
      )
    end

    it 'does not alter news-tyle attributes' do
      assert_compile(
        [:haml,
         :attrs,
         '(a=2)'],
        [:haml,
         :attrs,
         '(a=2)'],
      )
    end

    it 'convers only string' do
      assert_compile(
        [:haml,
         :attrs,
         [:html, :attr, 'id', [:static, 'foo']],
         '{ foo: "bar" }',
         [:html, :attr, 'class', [:static, 'bar']]],
        [:haml,
         :attrs,
         [:html, :attr, 'id', [:static, 'foo']],
         [:html, :attr, 'foo', [:dynamic, '"bar"']],
         [:html, :attr, 'class', [:static, 'bar']]],
      )
    end

    it 'converts nested attributes' do
      assert_compile(
        [:haml,
         :attrs,
         '{ a: { b: {}, c: "d" }, e: "f" }'],
        [:haml,
         :attrs,
         [:html, :attr, 'a-c', [:dynamic, '"d"']],
         [:html, :attr, 'e', [:dynamic, '"f"']]],
      )
    end
  end
end
