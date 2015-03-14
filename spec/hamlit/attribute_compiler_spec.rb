describe Hamlit::AttributeCompiler do
  describe '#on_html_attrs' do
    it 'wraps arguments with :multi' do
      attr = [:html, :attr, 'id', [:static, 'foo']]
      result = described_class.new.on_html_attrs(attr)
      expect(result).to eq([:multi, attr])
    end

    it 'wraps arguments with :multi' do
      attr1 = [:html, :attr, 'id', [:static, 'foo']]
      attr2 = [:html, :attr, 'class', [:static, 'bar']]
      result = described_class.new.on_html_attrs(attr1, attr2)
      expect(result).to eq([:multi, attr1, attr2])
    end

    it 'converts only string into dynamic value' do
      result = described_class.new.on_html_attrs('{ foo: "bar" }')
      attr   = [:html, :attr, 'foo', [:dynamic, '"bar"']]
      expect(result).to eq([:multi, attr])
    end

    it 'converts nested attributes' do
      result = described_class.new.on_html_attrs('{ a: { b: 3 } }')
      attr   = [:html, :attr, 'a-b', [:dynamic, '3']]
      expect(result).to eq([:multi, attr])
    end

    it 'wraps arguments with :multi' do
      attr1 = [:html, :attr, 'id', [:static, 'foo']]
      attr2 = '{ "foo" => "bar" }'
      result = described_class.new.on_html_attrs(attr1, attr2)

      converted_attr2 = [:html, :attr, 'foo', [:dynamic, '"bar"']]
      expect(result).to eq([:multi, attr1, converted_attr2])
    end
  end
end
