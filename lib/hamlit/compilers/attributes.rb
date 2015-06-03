require 'hamlit/compilers/new_attribute'
require 'hamlit/compilers/old_attribute'
require 'hamlit/compilers/runtime_attribute'
require 'hamlit/concerns/escapable'
require 'hamlit/concerns/included'

module Hamlit
  module Compilers
    module Attributes
      extend Concerns::Included
      include Compilers::NewAttribute
      include Compilers::OldAttribute
      include Compilers::RuntimeAttribute

      included do
        include Concerns::Escapable

        define_options :format, :attr_quote
      end

      def on_haml_attrs(*attrs)
        attrs = compile_attributes(attrs)
        attrs = join_ids(attrs)
        attrs = combine_classes(attrs)
        attrs = pull_class_first(attrs)
        attrs = sort_attributes(attrs) unless has_runtime_attribute?(attrs)

        if has_runtime_attribute?(attrs) && has_attr?(attrs, 'class', 'id')
          attrs = merge_runtime_attributes(attrs)
          return [:html, :attrs, *escape_attribute_values(attrs)]
        end
        attrs = attrs.map { |a| compile(a) }

        [:html, :attrs, *escape_attribute_values(attrs)]
      end

      private

      def escape_attribute_values(attrs)
        attrs.map do |attr|
          _, _, name, value = attr
          type, arg = value
          next attr unless name && type && type && arg

          [:html, :attr, name, escape_html(value, true)]
        end
      end

      def compile_attributes(exps)
        attrs = []
        exps.each do |exp|
          case exp
          when /\A\(.+\)\Z/
            attrs += compile_new_attribute(exp)
          when /\A{.+}\Z/
            attrs += compile_old_attribute(exp)
          else
            attrs << compile(exp)
          end
        end
        attrs
      end

      def pull_class_first(attrs)
        class_attrs = filter_attrs(attrs, 'class')
        combine_classes(class_attrs) + (attrs - class_attrs)
      end

      def combine_classes(attrs)
        class_attrs = filter_attrs(attrs, 'class')
        return attrs if class_attrs.length <= 1

        values = class_attrs.map(&:last).sort_by(&:last)
        [[:html, :attr, 'class', [:multi, *insert_static(values, ' ')]]] + (attrs - class_attrs)
      end

      def join_ids(attrs)
        id_attrs = filter_attrs(attrs, 'id')
        return attrs if id_attrs.length <= 1

        values = attrs.map(&:last)
        [[:html, :attr, 'id', [:multi, *insert_static(values, '_')]]] + (attrs - id_attrs)
      end

      def has_attr?(attrs, *targets)
        filter_attrs(attrs, *targets).any?
      end

      def filter_attrs(attrs, *targets)
        attrs.select do |html, attr, name, content|
          targets.include?(name)
        end
      end

      def insert_static(array, str)
        result = []
        array.each_with_index do |value, index|
          result << [:static, str] if index > 0
          result << value
        end
        result
      end

      def sort_attributes(attrs)
        attrs.sort_by do |(html, attr, name, content)|
          name
        end
      end
    end
  end
end
