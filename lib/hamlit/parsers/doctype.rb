require 'hamlit/concerns/error'

module Hamlit
  module Parsers
    module Doctype
      def parse_doctype(scanner)
        assert_scan!(scanner, /!!!/)

        type = nil
        if scanner.scan(/ +/) && scanner.rest?
          type = scanner.rest.strip
        end

        [:haml, :doctype, options[:format], type]
      end
    end
  end
end
