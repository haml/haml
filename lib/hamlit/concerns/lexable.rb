require 'ripper'

module Hamlit
  module Concerns
    module Lexable
      TYPE_POSITION = 1

      def skip_tokens!(tokens, *types)
        while types.include?(type_of(tokens.first))
          tokens.shift
        end
      end

      def type_of(token)
        return nil unless token
        token[TYPE_POSITION]
      end
    end
  end
end
