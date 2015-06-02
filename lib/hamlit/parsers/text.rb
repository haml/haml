require 'hamlit/concerns/error'

module Hamlit
  module Parsers
    module Text
      include Concerns::Error

      def parse_text(scanner, lstrip: false, escape: true)
        text = (scanner.scan(/.+/) || '')
        text = text.lstrip if lstrip
        [:haml, :text, text, escape]
      end
    end
  end
end
