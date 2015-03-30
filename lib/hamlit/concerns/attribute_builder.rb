module Hamlit
  module Concerns
    module AttributeBuilder
      def flatten_attributes(attributes)
        flattened = {}

        attributes.each do |key, value|
          case value
          when Hash
            flatten_attributes(value).each do |k, v|
              flattened["#{key}-#{k}"] = v
            end
          else
            flattened[key] = value
          end
        end
        flattened
      end
    end
  end
end
