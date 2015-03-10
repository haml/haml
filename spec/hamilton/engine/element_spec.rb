describe Hamilton::Engine do
  describe 'element' do
    it 'parses one-line element' do
      expect(render_string('%span hello')).to eq('<span>hello</span>')
    end

    it 'parses multi-line element' do
      expect(render_string(<<-HAML.unindent)).to eq("<span>hello</span>")
        %span
          hello
      HAML
    end
  end
end
