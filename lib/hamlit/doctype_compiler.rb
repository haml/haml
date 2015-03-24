require 'hamlit/filter'

module Hamlit
  class DoctypeCompiler < Hamlit::Filter
    def on_haml_doctype(format, type)
      case type
      when 'XML'
        return [:static, "<?xml version='1.0' encoding='utf-8' ?>"]
      end

      [:html, :doctype, convert_format(format, type).to_s]
    end

    private

    def convert_format(format, type)
      case format
      when :html4, :html5
        :html
      when :xhtml
        return type if type
        :transitional
      else
        format
      end
    end
  end
end
