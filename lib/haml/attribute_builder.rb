module Haml
  module AttributeBuilder
    def self.build_attributes(is_html, attr_wrapper, escape_attrs, hyphenate_data_attrs, attributes = {})
        # @TODO this is an absolutely ridiculous amount of arguments. At least
      # some of this needs to be moved into an instance method.
      quote_escape     = attr_wrapper == '"' ? "&#x0022;" : "&#x0027;"
      other_quote_char = attr_wrapper == '"' ? "'" : '"'
      join_char        = hyphenate_data_attrs ? '-' : '_'

      attributes.each do |key, value|
        if value.is_a?(Hash)
          data_attributes = attributes.delete(key)
          data_attributes = flatten_data_attributes(data_attributes, '', join_char)
          data_attributes = build_data_keys(data_attributes, hyphenate_data_attrs, key)
          attributes = data_attributes.merge(attributes)
        end
      end

      result = attributes.collect do |attr, value|
        next if value.nil?

        value = filter_and_join(value, ' ') if attr == 'class'
        value = filter_and_join(value, '_') if attr == 'id'

        if value == true
          next " #{attr}" if is_html
          next " #{attr}=#{attr_wrapper}#{attr}#{attr_wrapper}"
        elsif value == false
          next
        end

        escaped =
          if escape_attrs == :once
            Haml::Helpers.escape_once(value.to_s)
          elsif escape_attrs
            Haml::Helpers.html_escape(value.to_s)
          else
            value.to_s
          end
        value = Haml::Helpers.preserve(escaped)
        if escape_attrs
          # We want to decide whether or not to escape quotes
          value.gsub!(/&quot;|&#x0022;/, '"')
          this_attr_wrapper = attr_wrapper
          if value.include? attr_wrapper
            if value.include? other_quote_char
              value.gsub!(attr_wrapper, quote_escape)
            else
              this_attr_wrapper = other_quote_char
            end
          end
        else
          this_attr_wrapper = attr_wrapper
        end
        " #{attr}=#{this_attr_wrapper}#{value}#{this_attr_wrapper}"
      end
      result.compact!
      result.sort!
      result.join
    end

    def self.filter_and_join(value, separator)
      return '' if (value.respond_to?(:empty?) && value.empty?)

      if value.is_a?(Array)
        value.flatten!
        value.map! {|item| item ? item.to_s : nil}
        value.compact!
        value = value.join(separator)
      else
        value = value ? value.to_s : nil
      end
      !value.nil? && !value.empty? && value
    end

    def self.build_data_keys(data_hash, hyphenate, attr_name="data")
      Hash[data_hash.map do |name, value|
        if name == nil
          [attr_name, value]
        elsif hyphenate
          ["#{attr_name}-#{name.to_s.tr('_', '-')}", value]
        else
          ["#{attr_name}-#{name}", value]
        end
      end]
    end

    def self.flatten_data_attributes(data, key, join_char, seen = [])
      return {key => data} unless data.is_a?(Hash)

      return {key => nil} if seen.include? data.object_id
      seen << data.object_id

      data.sort {|x, y| x[0].to_s <=> y[0].to_s}.inject({}) do |hash, (k, v)|
        joined = key == '' ? k : [key, k].join(join_char)
        hash.merge! flatten_data_attributes(v, joined, join_char, seen)
      end
    end
  end
end
