require "abstract_controller/rendering"

# Rails 3.2.3's form helpers add a newline after opening textareas, which can
# cause problems with newlines being considered content rather than markup.
# These changes fix the issue by making the helpers emit "<haml:newline/>"
# rather than the leading newline. The tag is then replaced by a newline after
# rendering.
#
# This should be considered nothing more than an emergency hotfix to ensure
# compatibility with the latest version of Rails, made at a moment when the Haml
# project is transitioning to a new maintainer.

# module AbstractController
#   module Rendering
#     def render_to_body_with_haml(options = {})
#       if rendered = render_to_body_without_haml(options)
#         rendered.gsub('<haml:newline/>', "\n").html_safe
#       end
#     end
#     alias_method_chain :render_to_body, :haml
#   end
# end

module ActionView
  module Helpers

    module FormTagHelper
      def text_area_tag_with_haml(*args)
        text_area_tag_without_haml(*args).sub('>&#x000A;', ">\n").html_safe
      end
      alias_method_chain :text_area_tag, :haml
    end

    module FormHelper
      def text_area_with_haml(*args)
        text_area_without_haml(*args).sub('>&#x000A;', ">\n").html_safe
      end
      alias_method_chain :text_area, :haml
    end
  end
end