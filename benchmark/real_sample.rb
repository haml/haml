def render(*)
  '<div class="render"></div>'
end

def link_to(*args, &block)
  a, b, *c = args
  if block_given?
    "<a href='" << a << ">".freeze << yield.to_s << '</div>'.freeze
  else
    "<a href='" << a << ">".freeze << b.to_s << '</div>'.freeze
  end
end

def image_tag(*)
  '<img src="https://github.com/favicon.ico" />'
end
