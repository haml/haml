# frozen_string_literal: true

module Hamlit
  # Like Temple::Filters::Escapable, but with support for escaping by
  # Hamlit::HamlHerlpers.html_escape and Hamlit::HamlHerlpers.escape_once.
  class HamlEscapable < Temple::Filter
    # Special value of `flag` to ignore html_safe?
    EscapeSafeBuffer = Struct.new(:value)

    def initialize(*)
      super
      @escape = false
      @escape_safe_buffer = false
    end

    def on_escape(flag, exp)
      old_escape, old_escape_safe_buffer = @escape, @escape_safe_buffer
      @escape_safe_buffer = flag.is_a?(EscapeSafeBuffer)
      @escape = @escape_safe_buffer ? flag.value : flag
      compile(exp)
    ensure
      @escape, @escape_safe_buffer = old_escape, old_escape_safe_buffer
    end

    # The same as Hamlit::HamlAttributeBuilder.build_attributes
    def on_static(value)
      [:static,
       if @escape == :once
         escape_once(value)
       elsif @escape
         escape(value)
       else
         value
       end
      ]
    end

    # The same as Hamlit::HamlAttributeBuilder.build_attributes
    def on_dynamic(value)
      [:dynamic,
       if @escape == :once
         escape_once_code(value)
       elsif @escape
         escape_code(value)
       else
         "(#{value}).to_s"
       end
      ]
    end

    private

    def escape_once(value)
      if @escape_safe_buffer
        ::Hamlit::HamlHelpers.escape_once_without_haml_xss(value)
      else
        ::Hamlit::HamlHelpers.escape_once(value)
      end
    end

    def escape(value)
      if @escape_safe_buffer
        ::Hamlit::HamlHelpers.html_escape_without_haml_xss(value)
      else
        ::Hamlit::HamlHelpers.html_escape(value)
      end
    end

    def escape_once_code(value)
      "::Hamlit::HamlHelpers.escape_once#{('_without_haml_xss' if @escape_safe_buffer)}((#{value}))"
    end

    def escape_code(value)
      "::Hamlit::HamlHelpers.html_escape#{('_without_haml_xss' if @escape_safe_buffer)}((#{value}))"
    end
  end
end
