module Hamlit
  module TempleUtilsExtension
    def escape_html_safe(html)
      super(html.to_s)
    end
  end
end

Temple::Utils.send(:extend, Hamlit::TempleUtilsExtension)
