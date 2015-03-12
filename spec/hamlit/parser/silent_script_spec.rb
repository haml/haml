describe Hamlit::Parser do
  describe 'silent script' do
    it 'parses silent script' do
      assert_parse(<<-HAML) do
        - 2.times do |i|
          = i
      HAML
        [:multi,
         [:multi,
          [:code, ' 2.times do |i|'],
          [:dynamic, ' i'],
          [:static, "\n"],
          [:code, 'end']]]
      end
    end
  end
end
