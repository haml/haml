module Hamlit
  module Concerns
    module AttributeBuilder
      def flatten_attributes(attributes)
        flattened = {}

        attributes.each do |key, value|
          case value
          when Hash
            flatten_attributes(value).each do |k, v|
              k = k.to_s.gsub(/_/, '-')
              flattened["#{key}-#{k}"] = v if v
            end
          else
            flattened[key] = value if value
          end
        end
        flattened
      end
    end
  end
end
