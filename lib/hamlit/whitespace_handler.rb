module Hamlit
  class WhitespaceHandler
    def compile_children(node, &block)
      temple = [:multi]
      return temple if node.children.empty?

      temple << [:static, "\n"] if prepend_whitespace?(node)
      node.children.each do |n|
        temple << yield(n)
        temple << [:static, "\n"] if insert_whitespace?(n)
      end
      temple
    end

    private

    def prepend_whitespace?(node)
      case node.type
      when :tag
        true
      else
        false
      end
    end

    def insert_whitespace?(node)
      case node.type
      when :doctype
        node.value[:type] != 'xml'
      when :plain, :tag
        true
      else
        false
      end
    end
  end
end
