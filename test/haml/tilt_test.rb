# frozen_string_literal: true

describe Tilt::HamlTemplate do
  describe '#render' do
    def suppress_warning(&block)
      begin
        $VERBOSE, verbose = nil, $VERBOSE
        block.call
      ensure
        $VERBOSE = verbose
      end
    end

    it 'works normally' do
      template = suppress_warning { Tilt::HamlTemplate.new { "%p= name" } }
      assert_equal "<p>tilt</p>\n", template.render(Object.new, name: 'tilt')
    end
  end
end
