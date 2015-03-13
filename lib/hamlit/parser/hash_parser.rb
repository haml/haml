module Hamlit
  class Parser
    class HashParser
      def self.parse(line)
        return self.new(line).parse if line.is_a?(StringScanner)

        scanner = StringScanner.new(line)
        self.new(scanner).parse
      end

      attr_reader :scanner

      def initialize(scanner)
        @scanner = scanner
      end

      def parse
        return {} unless scanner.match?(/{/)

        parse_hash
      end

      private

      def parse_hash
        hash = {}

        scanner.scan(/{/)
        return hash if scanner.scan(/}/)

        key = parse_key
        value = scanner.scan_until(/}/)
        raise SyntaxError unless value

        hash[key] = value.gsub(/ *}$/, '')
        hash
      end

      def parse_key
        skip_whitespace
        unless scanner.scan(/:(\w+) *=>/) || scanner.scan(/(\w+):/)
          raise SyntaxError
        end

        key = scanner[1]
        skip_whitespace

        key
      end

      def skip_whitespace
        scanner.skip(/ +/)
      end
    end
  end
end
