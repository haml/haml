module Hamlit
  module Compilers
    module Doctype
      def on_haml_doctype(format, type)
        if type == 'XML'
          return xml_doctype_tag(format)
        elsif type
          return doctype_tag(type)
        end

        case format
        when :html4
          doctype_tag(:transitional)
        when :html5
          doctype_tag(:html)
        when :xhtml
          doctype_tag(:transitional)
        else
          doctype_tag(format)
        end
      end

      private

      def xml_doctype_tag(format)
        case format
        when :html4, :html5
          [:newline]
        else
          [:multi, [:static, "<?xml version='1.0' encoding='utf-8' ?>"], [:static, "\n"]]
        end
      end

      def doctype_tag(type)
        [:multi, [:html, :doctype, type.to_s], [:static, "\n"]]
      end
    end
  end
end
