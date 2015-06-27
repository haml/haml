module Hamlit
  module Concerns
    module StringInterpolation
      def string_literal(str)
        res = ''
        rest = handle_interpolation(str.inspect) do |scan|
          escapes = (scan[2].size - 1) / 2
          res << scan.matched[0...-3 - escapes]
          res << (escapes.odd? ? '#{' : unescape_interpolation(scan))
        end
        res + rest
      end

      def contains_interpolation?(str)
        /#[\{$@]/ === str
      end

      private

      def unescape_interpolation(scan)
        content = eval('"' + balance(scan, ?{, ?}, 1)[0][0...-1] + '"')
        '#{' + content + '}'
      end

      def handle_interpolation(str)
        scan = StringScanner.new(str)
        yield scan while scan.scan(/(.*?)(\\*)\#\{/)
        scan.rest
      end

      def balance(scanner, start, finish, count = 0)
        str = ''
        while balanced_scan(scanner, start, finish)
          str << scanner.matched
          count += 1 if scanner.matched[-1] == start
          count -= 1 if scanner.matched[-1] == finish
          return [str.strip, scanner.rest] if count == 0
        end
      end

      def balanced_scan(scanner, start, finish)
        regexp  = Regexp.new("(.*?)[\\#{start.chr}\\#{finish.chr}]", Regexp::MULTILINE)
        scanner = StringScanner.new(scanner) unless scanner.is_a?(StringScanner)
        scanner.scan(regexp)
      end
    end
  end
end
