module Hamlit
  class TagCompiler
    def self.compile(node)
      attrs = [:html, :attrs]
      node.value[:attributes_hashes].each do |attribute_hash|
        attrs << [:dynamic, "::Hamlit::AttributeBuilder.build(\"'\", #{attribute_hash})"]
      end
      node.value[:attributes].each do |name, value|
        attrs << [:html, :attr, name, [:static, value]]
      end
      [:html, :tag, node.value[:name], attrs, yield(node)]
    end
  end
end
