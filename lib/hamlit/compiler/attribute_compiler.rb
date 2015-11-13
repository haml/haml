require 'hamlit/attribute_builder'
require 'hamlit/hash_parser'
require 'hamlit/static_analyzer'

module Hamlit
  class Compiler
    class AttributeCompiler
      def initialize(options = {})
        @quote  = options[:attr_quote]
        @format = options[:format]
        @escape_attrs = options[:escape_attrs]
      end

      def compile(node)
        hashes = []
        node.value[:attributes_hashes].each do |attribute_str|
          hash = HashParser.parse(attribute_str)
          return runtime_compile(node) unless hash
          hashes << hash
        end
        static_compile(node.value[:attributes], hashes)
      end

      private

      def runtime_compile(node)
        attrs = node.value[:attributes_hashes]
        attrs.unshift(node.value[:attributes].inspect) if node.value[:attributes] != {}
        [:html,
         :attrs,
         [:dynamic,
          '::Hamlit::AttributeBuilder.build({ ' \
          "quote: #{@quote.inspect}, " \
          "format: #{@format.inspect}, " \
          "escape_attrs: #{@escape_attrs.inspect} " \
          "},#{attrs.join(', ')})",
         ],
        ]
      end

      def static_compile(static_hash, dynamic_hashes)
        temple = [:html, :attrs]
        keys = [*static_hash.keys, *dynamic_hashes.map(&:keys).flatten].uniq.sort
        keys.each do |key|
          static_value   = static_hash[key]
          dynamic_values = dynamic_hashes.map { |h| h[key] }.compact

          case key
          when 'id'.freeze
            compile_id!(temple, key, static_value, dynamic_values)
          when 'class'.freeze
            compile_class!(temple, key, static_value, dynamic_values)
          when 'data'.freeze
            compile_data!(temple, key, static_value, dynamic_values)
          when *AttributeBuilder::BOOLEAN_ATTRIBUTES, *AttributeBuilder::DATA_BOOLEAN_ATTRIBUTES
            compile_boolean!(temple, key, static_value, dynamic_values)
          else
            compile_common!(temple, key, static_value, dynamic_values)
          end
        end
        temple
      end

      def compile_id!(temple, key, static_value, dynamic_values)
        case
        when static_value && dynamic_values.empty?
          temple << build_attr(:static, key, static_value)
        else
          values = dynamic_values.dup
          values.unshift(static_value.inspect) if static_value
          temple << [
            :html,
            :attr,
            key,
            [:dynamic, "::Hamlit::AttributeBuilder.build_id(#{values.join(', ')})"],
          ]
        end
      end

      def compile_class!(temple, key, static_value, dynamic_values)
        case
        when static_value && dynamic_values.empty?
          temple << build_attr(:static, key, static_value)
        else
          values = dynamic_values.dup
          values << static_value.inspect if static_value
          temple << [
            :html,
            :attr,
            key,
            [:dynamic, "::Hamlit::AttributeBuilder.build_class(#{values.join(', ')})"],
          ]
        end
      end

      def compile_data!(temple, key, static_value, dynamic_values)
        case
        when static_value && dynamic_values.empty?
          temple << build_attr(:static, key, static_value)
        else
          values = dynamic_values.dup
          values << static_value.inspect if static_value
          temple << [:dynamic, "::Hamlit::AttributeBuilder.build_data(#{values.join(', ')})"]
        end
      end

      def compile_boolean!(temple, key, static_value, dynamic_values)
        value = static_value.inspect if static_value
        value = dynamic_values.last unless dynamic_values.empty?

        code = [
          %Q|case #{value}|,
          %Q|when true|,
          %Q|_buf << #{ (@format == :xhtml ? " #{key}=#{@quote}#{key}#{@quote}" : " #{key}").inspect }.freeze|,
          %Q|when false, nil|,
          %Q|else|,
          %Q|_buf << " #{key}='".freeze|,
          %Q|_buf << ::Temple::Utils.escape_html((#{value}))|,
          %Q|_buf << "'".freeze|,
          %Q|end|,
        ]

        if StaticAnalyzer.static?(value)
          temple << [:static, eval(['_buf = []', *code, '_buf.join'].join('; '))]
        else
          temple << [:code, code.join('; ')]
        end
      end

      def compile_common!(temple, key, static_value, dynamic_values)
        type, value = :static, static_value if static_value
        dynamic_values.each do |dynamic_value|
          type, value = :dynamic, dynamic_value
        end

        if type == :dynamic && StaticAnalyzer.static?(value)
          type, value = :static, eval("(#{value}).to_s")
        end

        temple << build_attr(type, key, value)
      end

      def build_attr(type, key, value)
        [:html, :attr, key, [:escape, @escape_attrs, [type, value]]]
      end
    end
  end
end
