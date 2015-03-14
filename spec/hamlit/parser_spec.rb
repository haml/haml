describe Hamlit::Parser do
  describe '#call' do
    def assert_ast(str, ast)
      result = described_class.new.call(str)
      expect(result).to eq(ast)
    end

    it 'parses tag' do
      assert_ast(
        '%span a',
        [:multi,
         [:html, :tag, 'span', [:haml, :attrs], [:static, 'a']],
         [:static, "\n"]],
      )
    end

    it 'just parses a string in attribute braces' do
      assert_ast(
        '%span{ a: 1, b: { c: 2 } }',
        [:multi,
         [:html, :tag, "span", [:haml, :attrs, "{ a: 1, b: { c: 2 } }"]],
         [:static, "\n"]],
      )
    end

    it 'parses class, id and attributes' do
      assert_ast(
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
         [:static, "\n"]],
      )
    end
  end
end
