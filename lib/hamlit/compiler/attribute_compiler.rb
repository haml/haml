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

          values = []
          values << [:static, static_hash[key]] if static_hash[key]
          dynamic_hashes.map do |hash|
            values << [:dynamic, hash[key]] if hash[key]
          end

          case key
          when 'id'.freeze
            compile_id!(temple, key, values)
          when 'class'.freeze
            compile_class!(temple, key, values)
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

      def compile_id!(temple, key, values)
        build_code = attribute_builder(:id, values)
        if values.all? { |type, exp| type == :static || StaticAnalyzer.static?(exp) }
          temple << [:html, :attr, key, [:static, eval(build_code)]]
        else
          temple << [:html, :attr, key, [:dynamic, build_code]]
        end
      end

      def compile_class!(temple, key, values)
        # NOTE: Haml does not sort classes if static
        if values.all? { |type, _| type == :static }
          values.each { |v| temple << build_attr(key, *v) }
          return
        end

        build_code = attribute_builder(:class, values)
        if values.all? { |type, exp| type == :static || StaticAnalyzer.static?(exp) }
          temple << [:html, :attr, key, [:static, eval(build_code)]]
        else
          temple << [:html, :attr, key, [:dynamic, build_code]]
        end
      end

      def compile_data!(temple, key, static_value, dynamic_values)
        case
        when static_value && dynamic_values.empty?
          temple << build_attr2(:static, key, static_value)
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
          %q|when true|,
            %Q|_buf << #{ (@format == :xhtml ? " #{key}=#{@quote}#{key}#{@quote}" : " #{key}").inspect }.freeze|,
          %q|when false, nil|,
          %q|else|,
            %Q|_buf << " #{key}='".freeze|,
            %Q|_buf << ::Temple::Utils.escape_html((#{value}))|,
            %q|_buf << "'".freeze|,
          %q|end|,
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

        temple << build_attr2(type, key, value)
      end

      def build_attr2(type, key, value)
        [:html, :attr, key, [:escape, @escape_attrs, [type, value]]]
      end

      def build_attr(key, type, exp)
        [:html, :attr, key, [:escape, @escape_attrs, [type, exp]]]
      end

      def attribute_builder(type, values)
        args = values.map { |type, exp|
          type == :static ? exp.inspect : exp
        }.join(', ')

        "::Hamlit::AttributeBuilder.build_#{type}(#{args})"
      end
    end
  end
end
