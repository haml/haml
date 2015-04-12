describe Hamlit::Engine do
  describe '.new' do
    subject { described_class.new(options) }

    let(:buffer)  { '_a' }
    let(:options) do
      {
        buffer:    buffer,
        generator: Temple::Generators::ArrayBuffer,
      }
    end

    it 'accepts generator valid options' do
      expect(subject.call('')).to eq(
        "#{buffer} = []; ; #{buffer} = #{buffer}.join",
      )
    end
  end

  describe '#call' do
    let(:haml) do
      <<-HAML.unindent
        !!! html

        %html
          %head
            %title Simple Haml
          %body
            %h1= 'header'
            - unless false
              %ul
                - for i in [1, 2, 3]
                  - if i
                    %li
                      %strong= 'hello'
                  - else
                    %li
                      %a{:href => i}= i
            - else
              %p last line
      HAML
    end
    let(:engine) { described_class.new }

    it 'generates code with the same lineno as a template' do
      lines = engine.call(haml).split("\n")
      expect(lines[0]).to include('DOCTYPE')
      expect(lines[6]).to include('header')
      expect(lines[7]).to include('unless')
      expect(lines[9]).to include('for i in')
      expect(lines[10]).to include('if i')
      expect(lines[12]).to include('hello')
      expect(lines[13]).to include('else')
      expect(lines[16]).to include('else')
      expect(lines[17]).to include('last line')
    end
  end
end
