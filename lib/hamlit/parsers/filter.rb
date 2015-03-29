require 'hamlit/concerns/error'
require 'hamlit/concerns/indentable'

module Hamlit
  module Parsers
    module Filter
      include Concerns::Indentable

      def parse_filter(scanner)
        assert_scan!(scanner, /:/)

        name = scanner.scan(/.+/).strip
        lines = with_indented { read_lines }
        [:haml, :filter, name, lines]
      end
    end
  end
end
