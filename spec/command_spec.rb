require 'spec_helper'
require './game/command'

RSpec.describe Command do
  subject { described_class.new command }
  let(:command) { "12" }

  describe '#initialize' do
    it { expect( subject.command ).to eq command }
    it { expect( subject.row ).to eq 0 }
    it { expect( subject.column ).to eq 1 }
    it { expect( subject.error ).to be_nil }
  end

  describe '#valid?' do
    context 'good command' do
      let(:command) { "22" }
      it { expect( subject.valid ).to be_truthy }
      it { expect( subject.error ).to be_nil }
    end

    context 'nil command' do
      let(:command) { nil }
      it { expect( subject.valid ).to be_falsey }
      it { expect( subject.error ).to eq "command was blank" }
    end

    context 'blank command' do
      let(:command) { "" }
      it { expect( subject.valid ).to be_falsey }
      it { expect( subject.error ).to eq "command was blank" }
    end

    context 'bad command' do
      let(:command) { "444" }
      it { expect( subject.valid ).to be_falsey }
      it { expect( subject.error ).to eq "command not in set" }
    end
  end
end