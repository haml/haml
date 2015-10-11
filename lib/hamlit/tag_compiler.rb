module Hamlit
  class TagCompiler
    def initialize(attr_quote)
      @quote = attr_quote.inspect.freeze
    end

    def compile(node, &block)
      attrs    = compile_attributes(node)
      contents = compile_contents(node, &block)
      [:html, :tag, node.value[:name], attrs, contents]
    end

    private

    def compile_attributes(node)
      attrs = [:html, :attrs]
      node.value[:attributes_hashes].each do |attribute_hash|
        attrs << [:dynamic, "::Hamlit::AttributeBuilder.build(#{@quote}, #{attribute_hash})"]
      end
      node.value[:attributes].each do |name, value|
        attrs << [:html, :attr, name, [:static, value]]
      end
      attrs
    end

    def compile_contents(node, &block)
      unless node.children.empty?
        return yield(node)
      end
      [:dynamic, node.value[:value]]
    end
  end
end
