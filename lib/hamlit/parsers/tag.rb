require 'hamlit/concerns/error'
require 'hamlit/concerns/indentable'
require 'hamlit/concerns/whitespace'
require 'hamlit/helpers'

module Hamlit
  module Parsers
    module Tag
      include Concerns::Error
      include Concerns::Indentable
      include Concerns::Whitespace

      TAG_ID_CLASS_REGEXP = /[a-zA-Z0-9_-]+/
      TAG_REGEXP  = /[a-zA-Z0-9\-_:]+/
      DEFAULT_TAG = 'div'

      def parse_tag(scanner)
        if scanner.scan(/%/)
          tag = scanner.scan(TAG_REGEXP)
          unless tag
            syntax_error!(%Q{Invalid tag: "#{scanner.string}".})
          end
        end
        tag ||= DEFAULT_TAG

        attrs = [:haml, :attrs]
        attrs += parse_tag_id_and_class(scanner)
        attrs += parse_attributes(scanner)

        ast = [:html, :tag, tag, attrs]
        inner_removal = parse_whitespace_removal(scanner)

        if !has_block? || scanner.match?(/=|&=|!=/)
          return syntax_error("Self-closing tags can't have content.") if scanner.scan(/\/ *[^ ]/)
          return ast if scanner.scan(/\//)
          return ast << parse_line(scanner, inline: true)
        elsif scanner.match?(/\//)
          return syntax_error("Illegal nesting: nesting within a self-closing tag is illegal.")
        end
        validate_content_existence!(tag, scanner)

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
        attributes.each do |attr, values|
          ast << [:html, :attr, attr, [:static, values.join(' ')]]
        end
        ast
      end

      def validate_content_existence!(tag, scanner)
        scanner.scan(/ */)

        if scanner.match?(/[^ ]/)
          syntax_error!("Illegal nesting: content can't be both given on the same line as %#{tag} and nested within it.")
        end
      end
    end
  end
end
