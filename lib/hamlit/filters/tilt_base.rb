require 'tilt'

module Hamlit
  class Filters
    class TiltBase < Base
      def self.render(name, source)
        text = ::Tilt["t.#{name}"].new { source }.render
        text.gsub!(/^/, '  '.freeze)
      end

      private

      def compile_with_tilt(node, name)
        if Haml::Util.contains_interpolation?(node.value[:text])
          dynamic_compile(node, name)
        else
          static_compile(node, name)
        end
      end

      def static_compile(node, name)
        [:static, TiltBase.render(name, node.value[:text])]
      end

      def dynamic_compile(node, name)
        source = Haml::Util.unescape_interpolation(node.value[:text])
        [:dynamic, "::Hamlit::Filters::TiltBase.render('#{name}', #{source})"]
      end
    end
  end
end
