require 'hamlit/concerns/format_normalizable'
require 'hamlit/filter'

module Hamlit
  class DoctypeCompiler < Hamlit::Filter
    include Concerns::FormatNormalizable

    def on_haml_doctype(format, type)
      case type
      when 'XML'
        return [:static, "<?xml version='1.0' encoding='utf-8' ?>"]
      end

      [:html, :doctype, normalize_format(format).to_s]
    end
  end
end
