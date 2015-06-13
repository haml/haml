require 'hamlit/concerns/error'

module Hamlit
  module Parsers
    module Text
      include Concerns::Error

      def parse_text(scanner, lstrip: false, escape: true, scan: nil, inline: true)
        reject_text_nesting! unless inline

        scanner.scan(scan) if scan
        text = (scanner.scan(/.+/) || '')
        text = text.lstrip if lstrip
        [:haml, :text, text, escape]
      end

      private

      def reject_text_nesting!
        return unless next_line

        if next_indent > @current_indent
          syntax_error!('Illegal nesting: nesting within plain text is illegal.')
        end
      end
    end
  end
end
