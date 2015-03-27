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
      class_attrs = attrs.select do |html, attr, name, content|
        name == 'class'
      end
      combine_classes(class_attrs) + (attrs - class_attrs)
    end

    # FIXME: can't parse '!'
    def combine_classes(attrs)
      return attrs if attrs.length <= 1

      values = []
      attrs.each do |html, attr, name, (type, value)|
        case type
        when :static
          values.push(value)
        when :dynamic
          values.unshift("\#{#{value}}")
        end
      end
      [[:html, :attr, 'class', [:dynamic, "%Q!#{values.join(' ')}!"]]]
    end
  end
end
