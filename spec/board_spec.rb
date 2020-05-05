require 'spec_helper'
require './game/board'
require './game/command'
require 'pry'

RSpec.describe Board do
  subject { described_class.new }
  let(:grid) { [%w(11 12 13), %w(21 22 23), %w(31 32 33)] }

  describe "#new" do
    it { expect( subject.grid ).to eq grid }
  end

  describe "#update_grid" do
    let(:commands) do
      %w(12 23 32).map { |command| Command.new command }
    end

    let(:grid) do
      g = [%w(11 12 13), %w(21 22 23), %w(31 32 33)]
      g[0][1] = "XX"
      g[1][2] = "XX"
      g[2][1] = "XX"
      g
    end

    before { subject.update_grid commands }
    it { expect( subject.grid ).to eq grid }
  end
end