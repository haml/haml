module Hamlit
  class DoctypeCompiler
    def initialize(options = {})
      @format = options[:format]
      @html_type = options[:html_type]
    end

    def compile(node)
      case node.value[:type]
      when 'xml'
        xml_doctype
      when ''
        html_doctype(node)
      else
        [:html, :doctype, node.value[:type]]
      end
    end

    private

    def html_doctype(node)
      return [:html, :doctype, @html_type] if @html_type

      version = node.value[:version] || 'transitional'
      case @format
      when :xhtml
        [:html, :doctype, version]
      else
        [:html, :doctype, @format]
      end
    end

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
