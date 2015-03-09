describe Hamilton::Engine do
  describe 'doctype' do
    it 'renders html5 doctype' do
      expect(render_string('!!!')).to eq('<!DOCTYPE html>')
    end
  end
end
