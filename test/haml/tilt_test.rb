describe Tilt::HamlTemplate do
  describe '#render' do
    it 'works normally' do
      template = Tilt::HamlTemplate.new { "%p= name" }
      assert_equal "<p>tilt</p>\n", template.render(Object.new, name: 'tilt')
    end
  end
end
