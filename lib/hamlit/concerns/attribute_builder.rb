module Hamlit
  module Concerns
    module AttributeBuilder
      IGNORED_EXPRESSIONS = %w[false nil].freeze

      def format_attributes(attributes)
        attributes = flatten_attributes(attributes)
        ignore_values(attributes)
      end

      def flatten_attributes(attributes)
        flattened = {}

        attributes.each do |key, value|
          case value
          when Hash
            flatten_attributes(value).each do |k, v|
              flattened["#{key}-#{k}"] = v if v
            end
          else
            flattened[key] = value if value
          end
        end
        flattened
      end

      private

      def ignore_values(attributes)
        attributes = attributes.dup
        attributes.each do |key, value|
          attributes.delete(key) if IGNORED_EXPRESSIONS.include?(value)
        end
      end
    end
  end
end
