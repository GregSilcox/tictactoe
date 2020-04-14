require './game/memory'

RSpec.describe Memory do
  subject { described_class.new }

  describe '.new' do
    it { expect( subject ).to be_a Memory }
  end

  describe '#get/#set' do
    let(:key) { 'test-1' }
    let(:value) { 'test-value-1' }

    before do
      subject.local
      subject.connect
      subject.set key, value
    end

    it { expect( subject.get key ).to eq value }
  end
end