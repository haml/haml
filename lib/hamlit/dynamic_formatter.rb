require 'hamlit/filter'

module Hamlit
  class DynamicFormatter < Hamlit::Filter
    def on_dynamic(exp)
      [:dynamic, "(#{exp}).to_s"]
    end
  end
end
