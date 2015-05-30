module Hamlit
  module Parsers
    module Text
      def parse_text(scanner)
        ast = [:haml, :text]
        ast << (scanner.scan(/.+/) || '').strip
        ast
      end
    end
  end
end
