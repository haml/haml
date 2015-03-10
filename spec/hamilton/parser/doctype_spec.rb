describe Hamilton::Parser do
  describe 'doctype' do
    it 'parses html5 doctype' do
      assert_parse(<<-HAML) do
        !!!
      HAML
        [:multi, [:html, :doctype, 'html'], [:static, "\n"]]
      end
    end
  end
end
