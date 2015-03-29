module Hamlit
  module Compilers
    module Comment
      def on_haml_comment(condition, exps)
        content = [:multi]
        content << [:static, "#{condition}>\n"]
        content += exps.map { |exp| compile(exp) }
        content << [:static, "<![endif]"]
        [:html, :comment, content]
      end
    end
  end
end
