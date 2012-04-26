# Rails 3.2.3's form helpers add a newline after opening textareas, which can
# cause problems with newlines being considered content rather than markup.
# These changes fix the issue by making the helpers emit "<haml:newline/>"
# rather than the leading newline. The tag is then replaced by a newline after
# rendering.
#
# This should be considered nothing more than an emergency hotfix to ensure
# compatibility with the latest version of Rails, made at a moment when the Haml
# project is transitioning to a new maintainer.

module AbstractController
  module Rendering
    def render_to_body_with_haml(options = {})
      if rendered = render_to_body_without_haml(options)
        rendered.gsub('<haml:newline/>', "\n").html_safe
      end
    end
    alias_method_chain :render_to_body, :haml
  end
end

module ActionView

  class Renderer
    def render_template_with_haml(context, options)
      if rendered = render_template_without_haml(context, options)
        rendered.gsub('<haml:newline/>', "\n").html_safe
      end
    end
    alias_method_chain :render_template, :haml
  end

  module Helpers
    module TagHelper
      private

      def content_tag_string_with_haml(name, content, options, escape = true)
        if name.to_sym == :textarea
          tag_options = tag_options(options, escape) if options
          content = ERB::Util.h(content) if escape
          "<#{name}#{tag_options}><haml:newline/>#{content}</#{name}>".html_safe
        else
          content_tag_string_without_haml(name, content, options, escape)
        end
      end
      alias_method_chain :content_tag_string, :haml
    end
  end
end