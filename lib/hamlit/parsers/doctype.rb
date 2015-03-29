module Hamlit
  module Parsers
    module Doctype
      def parse_doctype(scanner)
        raise SyntaxError unless scanner.scan(/!!!/)

        type = nil
        if scanner.scan(/ +/) && scanner.rest?
          type = scanner.rest.strip
        end

        [:haml, :doctype, options[:format], type]
      end
    end
  end
end
