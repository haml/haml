require 'hamlit/attribute'
require 'hamlit/concerns/string_interpolation'

# This module compiles :runtime sexp. It is a special version of
# old-style attribute which is built on runtime.
module Hamlit
  module Compilers
    module RuntimeAttribute
      include Concerns::StringInterpolation

      # This is used for compiling only runtime attribute in Compilers::Attribute.
      def on_runtime(str)
        compile_runtime_attribute(str)
      end

      # Given html attrs, merge classes and ids to :dynamic_attribute.
      def merge_runtime_attributes(attrs)
        merge_targets = filter_attrs(attrs, 'id', 'class')
        dynamic_attr  = attrs.find { |exp, *args| exp == :runtime }

        attrs -= merge_targets
        attrs.delete(dynamic_attr)

        base = decompile_temple_attrs(merge_targets)
        [compile_runtime_attribute(dynamic_attr.last, base), *attrs]
      end

      private

      def compile_runtime_attribute(str, base = nil)
        str = str.gsub(/(\A\{|\}\Z)/, '')
        quote = options[:attr_quote].inspect
        code = "::Hamlit::Attribute.build(#{[quote, base, str].compact.join(', ')})"
        [:dynamic, code]
      end

      def has_runtime_attribute?(attrs)
        attrs.any? do |exp, *args|
          exp == :runtime
        end
      end

      # Given attrs in temple ast, return an attribute as hash literal.
      def decompile_temple_attrs(attrs)
        literal = '{'
        attrs.each do |html, attr, name, (type, value)|
          case type
          when :static
            literal += ":#{name}=>#{string_literal(value)},"
          when :dynamic
            literal += ":#{name}=>#{value},"
          end
        end
        literal.gsub(/,\Z/, '') + '}'
      end
    end
  end
end
