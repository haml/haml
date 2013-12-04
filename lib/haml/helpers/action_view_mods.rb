module ActionView
  class Base
    def render_with_haml(*args, &block)
      options = args.first

      # If render :layout is used with a block, it concats rather than returning
      # a string so we need it to keep thinking it's Haml until it hits the
      # sub-render.
      if is_haml? && !(options.is_a?(Hash) && options[:layout] && block_given?)
        return non_haml { render_without_haml(*args, &block) }
      end
      render_without_haml(*args, &block)
    end
    alias_method :render_without_haml, :render
    alias_method :render, :render_with_haml

    def output_buffer_with_haml
      return haml_buffer.buffer if is_haml?
      output_buffer_without_haml
    end
    alias_method :output_buffer_without_haml, :output_buffer
    alias_method :output_buffer, :output_buffer_with_haml

    def set_output_buffer_with_haml(new_buffer)
      if is_haml?
        if Haml::Util.rails_xss_safe? && new_buffer.is_a?(ActiveSupport::SafeBuffer)
          new_buffer = String.new(new_buffer)
        end
        haml_buffer.buffer = new_buffer
      else
        set_output_buffer_without_haml new_buffer
      end
    end
    alias_method :set_output_buffer_without_haml, :output_buffer=
    alias_method :output_buffer=, :set_output_buffer_with_haml
  end

  module Helpers
    module CaptureHelper
      def capture_with_haml(*args, &block)
        if Haml::Helpers.block_is_haml?(block)
          #double assignment is to avoid warnings
          _hamlout = _hamlout = eval('_hamlout', block.binding) # Necessary since capture_haml checks _hamlout

          str = capture_haml(*args, &block)

          # NonCattingString is present in Rails less than 3.1.0. When support
          # for 3.0 is dropped, this can be removed.
          return ActionView::NonConcattingString.new(str) if str && defined?(ActionView::NonConcattingString)
          return str
        else
          capture_without_haml(*args, &block)
        end
      end
      alias_method :capture_without_haml, :capture
      alias_method :capture, :capture_with_haml
    end

    module TagHelper
      def content_tag_with_haml(name, *args, &block)
        return content_tag_without_haml(name, *args, &block) unless is_haml?

        preserve = haml_buffer.options[:preserve].include?(name.to_s)

        if block_given? && block_is_haml?(block) && preserve
          return content_tag_without_haml(name, *args) {preserve(&block)}
        end

        content = content_tag_without_haml(name, *args, &block)
        content = Haml::Helpers.preserve(content) if preserve && content
        content
      end

      alias_method :content_tag_without_haml, :content_tag
      alias_method :content_tag, :content_tag_with_haml
    end

    module HamlSupport
      include Haml::Helpers

      def haml_buffer
        @template_object.send :haml_buffer
      end

      def is_haml?
        @template_object.send :is_haml?
      end
    end

    if ActionPack::VERSION::MAJOR == 4
      module Tags
        class TextArea
          include HamlSupport
        end
      end
    end

    class InstanceTag
      include HamlSupport

      def content_tag(*args, &block)
        html_tag = content_tag_with_haml(*args, &block)
        return html_tag unless respond_to?(:error_wrapping)
        return error_wrapping(html_tag) if method(:error_wrapping).arity == 1
        return html_tag unless object.respond_to?(:errors) && object.errors.respond_to?(:on)
        return error_wrapping(html_tag, object.errors.on(@method_name))
      end
    end

    module FormTagHelper
      def form_tag_with_haml(url_for_options = {}, options = {}, *parameters_for_url, &proc)
        if is_haml?
          wrap_block = block_given? && block_is_haml?(proc)
          if wrap_block
            oldproc = proc
            proc = haml_bind_proc do |*args|
              concat "\n"
              with_tabs(1) {oldproc.call(*args)}
            end
          end
          res = form_tag_without_haml(url_for_options, options, *parameters_for_url, &proc) + "\n"
          res << "\n" if wrap_block
          res
        else
          form_tag_without_haml(url_for_options, options, *parameters_for_url, &proc)
        end
      end
      alias_method :form_tag_without_haml, :form_tag
      alias_method :form_tag, :form_tag_with_haml
    end

    module FormHelper
      def form_for_with_haml(object_name, *args, &proc)
        wrap_block = block_given? && is_haml? && block_is_haml?(proc)
        if wrap_block
          oldproc = proc
          proc = proc {|*subargs| with_tabs(1) {oldproc.call(*subargs)}}
        end
        res = form_for_without_haml(object_name, *args, &proc)
        res << "\n" if wrap_block
        res
      end
      alias_method :form_for_without_haml, :form_for
      alias_method :form_for, :form_for_with_haml
    end
  end
end