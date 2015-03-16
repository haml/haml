describe Hamlit::Parser do
  describe '#call' do
    it 'parses tag' do
      assert_compile(
        '%span a',
        [:multi,
         [:html, :tag, 'span', [:haml, :attrs], [:haml, :text, 'a']],
         [:static, "\n"],
         [:newline]],
      )
    end

    it 'just parses a string in attribute braces' do
      assert_compile(
        '%span{ a: 1, b: { c: 2 } }',
        [:multi,
         [:html, :tag, "span", [:haml, :attrs, "{ a: 1, b: { c: 2 } }"]],
         [:static, "\n"],
         [:newline]],
      )
    end

    it 'parses class, id and attributes' do
      assert_compile(
        '#foo.bar{ baz: 1 }',
        [:multi,
         [:html,
          :tag,
          'div',
          [:haml,
           :attrs,
           [:html, :attr, 'id', [:static, 'foo']],
           [:html, :attr, 'class', [:static, 'bar']],
           '{ baz: 1 }']],
         [:static, "\n"],
         [:newline]],
      )
    end
  end
end
