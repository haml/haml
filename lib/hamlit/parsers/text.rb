require 'hamlit/concerns/error'

module Hamlit
  module Parsers
    module Text
      include Concerns::Error

      def parse_text(scanner, lstrip: false)
        scanner.scan(/ +/) if lstrip

        ast = [:haml, :text]
        ast << (scanner.scan(/.+/) || '')
        ast
      end

      def parse_unescaped_text(scanner)
        assert_scan!(scanner, /! /)
        scanner.scan(/ +/)

        text = (scanner.scan(/.+/) || '')
        [:haml, :text, text, false]
      end
    end
  end
end
