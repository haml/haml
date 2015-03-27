require 'hamlit/filter'

# Haml-spec specifies attribute order inspite of an original order.
# Because temple's parser should return a result as original as possible,
# ordering of it is delegated to this filter.
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

    def combine_classes(attrs)
      return attrs if attrs.length <= 1

      values = []
      attrs.each_with_index do |(html, attr, name, value), index|
        type, str = value
        case type
        when :static
          values.push(value)
        when :dynamic
          values.unshift(value)
        end
      end
      [[:html, :attr, 'class', [:multi, *insert_spaces(values)]]]
    end

    def insert_spaces(array)
      result = []
      array.each_with_index do |value, index|
        result << [:static, ' '] if index > 0
        result << value
      end
      result
    end
  end
end
