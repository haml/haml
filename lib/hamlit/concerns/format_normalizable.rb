module Hamlit
  module Concerns
    module FormatNormalizable
      def normalize_format(format)
        return :html unless format

        case format
        when :html4, :html5
          :html
        else
          format
        end
      end
    end
  end
end
