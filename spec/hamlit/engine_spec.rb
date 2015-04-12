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
end
