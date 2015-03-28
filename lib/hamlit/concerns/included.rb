# Mini ActiveSupport::Concern
module Hamlit
  module Concerns
    class MultipleIncludedBlocks < StandardError
      def initialize
        super "Cannot define multiple 'included' blocks for a Concern"
      end
    end

    module Included
      def self.extended(klass)
        klass.class_eval do
          def self.included(base = nil, &block)
            if block_given?
              raise MultipleIncludedBlocks if defined?(@_included_block)

              @_included_block = block
              return
            end

            base.instance_exec(&@_included_block) if defined?(@_included_block)
            super
          end
        end
      end
    end
  end
end
