module Hamlit
  class DoctypeCompiler
    def initialize(options = {})
      @format = options[:format]
    end

    def compile(node)
      case node.value[:type]
      when 'xml'
        xml_doctype
      else
        [:html, :doctype, node.value[:type]]
      end
    end

    private

    def xml_doctype
      case @format
      when :xhtml
        [:static, "<?xml version='1.0' encoding='utf-8' ?>\n"]
      else
        [:multi]
      end
    end
  end
end
