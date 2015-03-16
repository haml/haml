require 'temple/html/filter'

module Hamlit
  class DynamicFormatter < Temple::HTML::Filter
    def on_dynamic(exp)
      [:dynamic, "(#{exp}).to_s"]
    end
  end
end
