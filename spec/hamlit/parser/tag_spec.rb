describe Hamlit::Parser do
  describe 'tag' do
    it 'parses one-line tag' do
      assert_parse(<<-HAML) do
        %span hello
      HAML
        [:multi,
         [:html, :tag, 'span', [:html, :attrs], [:static, 'hello']],
         [:static, "\n"]]
      end
    end

    it 'parses multine tag' do
      assert_parse(<<-HAML) do
        %span
          hello
      HAML
        [:multi,
         [:html,
          :tag,
          'span',
          [:html, :attrs],
          [:multi, [:static, "\n"], [:static, 'hello'], [:static, "\n"]]],
         [:static, "\n"]]
      end
    end
  end
end
