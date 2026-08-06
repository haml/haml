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

    it 'renders interpolated content calling yield' do
      haml = <<-'HAML'.unindent
        :plain
          #{yield(:title)}!
      HAML

      assert_equal(%Q|Painel!\n\n|, Haml::Template.new({}) { haml }.render(Object.new) { |_key| 'Painel' })
    end

    # The template author's mistake belongs to the generated code, not to compilation.
    it 'compiles interpolated content that does not parse' do
      haml = <<-'HAML'.unindent
        :plain
          #{1 +}
      HAML

      Haml::Engine.new.call(haml)
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
