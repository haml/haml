require 'hamlit/filter'

# Haml-spec specifies attribute order inspite of an original order.
# Because temple's parser should return a result as original as possible,
# the ordering delegated to this filter.
module Hamlit
  class AttributeSorter < Hamlit::Filter
    def on_haml_attrs(*attrs)
      [:html, :attrs, *pull_class_first(attrs)]
    end

    private

    def pull_class_first(attrs)
      class_attr = attrs.select do |html, attr, name, content|
        name == 'class'
      end
      class_attr + (attrs - class_attr)
    end
  end
end
