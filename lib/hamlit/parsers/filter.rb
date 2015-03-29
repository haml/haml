require 'hamlit/concerns/indentable'

module Hamlit
  module Parsers
    module Filter
      include Concerns::Indentable

      def parse_filter(scanner)
        raise SyntaxError unless scanner.scan(/:/)

        name = scanner.scan(/.+/).strip
        lines = with_indented { read_lines }
        [:haml, :filter, name, lines]
      end
    end
  end
end
