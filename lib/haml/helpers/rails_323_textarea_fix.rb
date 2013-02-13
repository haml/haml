# As of 3.2.3, Rails's form helpers add a newline after opening textareas,
# which can cause problems with newlines being considered content rather than
# markup. Here we decode the first newline back into a real newline to make the
# textarea work as expected. Note that in order for this to work, the compiler
# code was also change to avoid indenting code with textareas, even when Haml
# is running in indented mode.
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
