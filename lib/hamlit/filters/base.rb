module Hamlit
  module Filters
    class Base
      attr_reader :options

      def self.indent_source(source, indent_width: 0)
        lines = source.split("\n")
        self.new.compile_lines(lines, indent_width: indent_width)
      end

      def initialize(options = {})
        @options = options
      end

      def compile(lines)
        raise NotImplementedError
      end

      def compile_lines(lines, indent_width: 0)
        base  = (lines.first || '').index(/[^\s]/) || 0
        width = indent_width - base
        width = 0 if width < 0

        lines = strip_last(lines).map do |line|
          ' ' * width + line
        end

        text = lines.join("\n") + "\n"
        text
      end

      private

      # NOTE: empty line is reserved for preserve filter.
      def strip_last(lines)
        lines = lines.dup
        while lines.last && lines.last.length == 0
          lines.delete_at(-1)
        end
        lines
      end

      def compile_html(tag, lines)
        ast = [:haml, :text, compile_lines(lines, indent_width: 2), false]
        ast = [:multi, [:static, "\n"], ast]
        ast = [:html, :tag, tag, [:html, :attrs], ast]
        ast
      end

      def compile_xhtml(tag, type, lines)
        attr  = [:html, :attr, 'type', [:static, type]]
        attrs = [:html, :attrs, attr]

        content = [:haml, :text, compile_lines(lines, indent_width: 4)]
        multi = [:multi, [:static, "\n"], *cdata_for(type, content)]
        [:html, :tag, tag, attrs, multi]
      end

      def cdata_for(type, ast)
        case type
        when 'text/javascript'
          [[:static, "  //<![CDATA[\n"], ast, [:static, "  //]]>\n"]]
        when 'text/css'
          [[:static, "  /*<![CDATA[*/\n"], ast, [:static, "  /*]]>*/\n"]]
        end
      end
    end
  end
end
