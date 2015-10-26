module Hamlit
  class Filters
    class TiltBase < Base
      class << self
        def render(name, source)
          text = ::Tilt["t.#{name}"].new { source }.render
          text.gsub!(/^/, '  '.freeze)
        end
      end
    end
  end
end
