require 'tilt'

module Hamlit
  class Filters
    class TiltBase < Base
      def self.render(name, source, indent_width: 0)
        text = ::Tilt["t.#{name}"].new { source }.render
        return text if indent_width == 0
        text.gsub!(/^/, ' '.freeze * indent_width)
      end

      private

      def compile_with_tilt(node, name, indent_width: 0)
        if ::Hamlit::HamlUtil.contains_interpolation?(node.value[:text])
          dynamic_compile(node, name, indent_width: indent_width)
        else
          static_compile(node, name, indent_width: indent_width)
        end
      end

      def static_compile(node, name, indent_width: 0)
        [:static, TiltBase.render(name, node.value[:text], indent_width: indent_width)]
      end

      def dynamic_compile(node, name, indent_width: 0)
        source = ::Hamlit::HamlUtil.unescape_interpolation(node.value[:text])
        [:dynamic, "::Hamlit::Filters::TiltBase.render('#{name}', #{source}, indent_width: #{indent_width})"]
      end
    end
  end
end
