require 'hamlit/hamlit'
require 'hamlit/object_ref'
require 'hamlit/utils'

module Hamlit::AttributeBuilder
  BOOLEAN_ATTRIBUTES = %w[disabled readonly multiple checked autobuffer
                       autoplay controls loop selected hidden scoped async
                       defer reversed ismap seamless muted required
                       autofocus novalidate formnovalidate open pubdate
                       itemscope allowfullscreen default inert sortable
                       truespeed typemustmatch].freeze

  # NOTE: Since this module is used on runtime, its methods are designed to be
  # class methods which takes all options as arguments for performance.
  class << self
    def build(escape_attrs, quote, format, object_ref, *hashes)
      hashes << Hamlit::ObjectRef.parse(object_ref) if object_ref
      buf  = []
      hash = merge_all_attrs(hashes)

      keys = hash.keys.sort!
      keys.each do |key|
        case key
        when 'id'.freeze
          buf << " id=#{quote}#{build_id(escape_attrs, *hash[key])}#{quote}"
        when 'class'.freeze
          buf << " class=#{quote}#{build_class(escape_attrs, *hash[key])}#{quote}"
        when 'data'.freeze
          buf << build_data(escape_attrs, quote, *hash[key])
        when *BOOLEAN_ATTRIBUTES, /\Adata-/
          build_boolean!(escape_attrs, quote, format, buf, key, hash[key])
        else
          buf << " #{key}=#{quote}#{escape_html(escape_attrs, hash[key].to_s)}#{quote}"
        end
      end
      buf.join
    end

    private

    def merge_all_attrs(hashes)
      merged = {}
      hashes.each do |hash|
        hash.each do |key, value|
          key = key.to_s
          case key
          when 'id'.freeze, 'class'.freeze, 'data'.freeze
            merged[key] ||= []
            merged[key] << value
          else
            merged[key] = value
          end
        end
      end
      merged
    end

    def build_boolean!(escape_attrs, quote, format, buf, key, value)
      case value
      when true
        case format
        when :xhtml
          buf << " #{key}=#{quote}#{key}#{quote}"
        else
          buf << " #{key}"
        end
      when false, nil
        # omitted
      else
        buf << " #{key}=#{quote}#{escape_html(escape_attrs, value)}#{quote}"
      end
    end

    def escape_html(escape_attrs, str)
      if escape_attrs
        Hamlit::Utils.escape_html(str)
      else
        str
      end
    end
  end
end
