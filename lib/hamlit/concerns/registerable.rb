module Hamlit
  class NotFound < StandardError
    def initialize(name)
      super(%Q{Filter "#{name}" is not defined.})
    end
  end

  module Concerns
    module Registerable
      def registered
        @registered ||= {}
      end

      def register(name, compiler)
        registered[name.to_sym] = compiler
      end

      def find(name)
        raise NotFound.new(name) unless registered[name.to_sym]
        registered[name.to_sym]
      end
    end
  end
end
