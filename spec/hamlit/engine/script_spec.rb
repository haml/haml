describe Hamlit::Engine do
  describe 'script' do
    it 'renders one-line script' do
      assert_render(<<-HAML, <<-HTML)
        = 1 + 2
        %span= 3 * 4
      HAML
        3
        <span>12</span>
      HTML
    end

    it 'renders multi-lines script' do
      assert_render(<<-HAML, <<-HTML)
        %span
          = 1 + 2
          4 / 2
          %a= 3 - 4
      HAML
        <span>
        3
        4 / 2
        <a>-1</a>
        </span>
      HTML
    end

    it 'renders block script' do
      assert_render(<<-HAML, <<-HTML)
        = 3.times do |i|
          = i
        4
      HAML
        0
        1
        2
        3
        4
      HTML
    end
  end
end
