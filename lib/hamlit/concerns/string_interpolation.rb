module Hamlit
  module Concerns
    module StringInterpolation
      def string_literal(str)
        unescape_interpolation(str)
      end

      def contains_interpolation?(str)
        /#[\{$@]/ === str
      end

      private

      def unescape_interpolation(str)
        res = ''
        rest = handle_interpolation(str.inspect) do |scan|
          escapes = (scan[2].size - 1) / 2
          res << scan.matched[0...-3 - escapes]
          if escapes % 2 == 1
            res << '#{'
          else
            content = eval('"' + balance(scan, ?{, ?}, 1)[0][0...-1] + '"')
            res << '#{' + content + '}'
          end
        end
        res + rest
      end

      def handle_interpolation(str)
        scan = StringScanner.new(str)
        yield scan while scan.scan(/(.*?)(\\*)\#\{/)
        scan.rest
      end

      def balance(scanner, start, finish, count = 0)
        str = ''
        scanner = StringScanner.new(scanner) unless scanner.is_a? StringScanner
        regexp = Regexp.new("(.*?)[\\#{start.chr}\\#{finish.chr}]", Regexp::MULTILINE)
        while scanner.scan(regexp)
          str << scanner.matched
          count += 1 if scanner.matched[-1] == start
          count -= 1 if scanner.matched[-1] == finish
          return [str.strip, scanner.rest] if count == 0
        end
      end
    end
  end
end
