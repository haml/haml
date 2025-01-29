# frozen_string_literal: true

describe Haml::Filters do
  include RenderHelper

  describe '#compile' do
    it 'does not escape content without interpolation' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <script>
      HTML
        :plain
          <script>
      HAML
    end

    it 'does not escape interpolated content' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <script>
        <script>

      HTML
        :plain
          <script>
          #{'<script>'}
      HAML
    end
  end
end
