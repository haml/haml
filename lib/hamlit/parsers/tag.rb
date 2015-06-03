require 'hamlit/concerns/error'
require 'hamlit/concerns/indentable'
require 'hamlit/helpers'

module Hamlit
  module Parsers
    module Tag
      include Concerns::Error
      include Concerns::Indentable

      TAG_ID_CLASS_REGEXP = /[a-zA-Z0-9_-]+/
      TAG_REGEXP  = /[a-zA-Z0-9\-_:]+/
      DEFAULT_TAG = 'div'

      def parse_tag(scanner)
        tag = DEFAULT_TAG
        tag = scanner.scan(TAG_REGEXP) if scanner.scan(/%/)

        attrs = [:haml, :attrs]
        attrs += parse_tag_id_and_class(scanner)
        attrs += parse_attributes(scanner)

        inner_removal = parse_whitespace_removal(scanner)
        ast = [:html, :tag, tag, attrs]

        if scanner.match?(/=/)
          ast << parse_script(scanner)
          return ast
        elsif scanner.scan(/\//)
          return ast
        elsif scanner.rest.match(/[^ ]/)
          ast << parse_text(scanner, lstrip: true)
          return ast
        elsif next_indent <= @current_indent
          return ast << [:multi]
        end

        content = [:multi, [:static, "\n"]]
        if inner_removal || Helpers::DEFAULT_PRESERVE_TAGS.include?(tag)
          content[0, 1] = [:haml, :strip]
        end
        content += with_tag_nested { parse_lines }
        ast << content
        ast
      end

      private

      def parse_tag_id_and_class(scanner)
        attributes = Hash.new { |h, k| h[k] = [] }

        while prefix = scanner.scan(/[#.]/)
          name = assert_scan!(scanner, TAG_ID_CLASS_REGEXP)

          case prefix
          when '#'
            attributes['id'] = [name]
          when '.'
            attributes['class'] << name
          end
        end

        ast = []
        attributes.each do |name, values|
          ast << [:html, :attr, name, [:static, values.join(' ')]]
        end
        ast
      end
    end
  end
end
