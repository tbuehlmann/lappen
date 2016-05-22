require 'spec_helper'

describe Lappen::Performer, pending: 'Waiting for RSpec 3.5.0' do
  subject { described_class.new(filters, double('scope'), {}) }
  let(:filters) { [[FilterOne, [], {}], [FilterTwo, [], {}]] }

  before do
    stub_const('FilterOne', Class.new(Lappen::Filter))
    stub_const('FilterTwo', Class.new(Lappen::Filter))
    stub_const('Halter',    Class.new(Lappen::Filter))

    allow_any_instance_of(FilterOne).to receive(:perform).and_return('1')
    allow_any_instance_of(FilterTwo).to receive(:perform).and_return('2')
    allow_any_instance_of(Halter).   to receive(:perform).and_throw(:halt, 'halted')
  end

  describe '#perform' do
    it 'performs each Filter' do
      expect_any_instance_of(FilterOne).to receive(:perform)
      expect_any_instance_of(FilterTwo).to receive(:perform)

      subject.perform
    end

    it 'returns the scope returned by the last Filter' do
      expect(subject.perform).to eq('2')
    end

    context 'using a Filter that halts' do
      let(:filters) { [[Halter, [], {}], [FilterOne, [], {}]] }

      it 'catches :halt and returns the result' do
        expect_any_instance_of(FilterOne).not_to receive(:perform)
        expect(subject.perform).to eq('halted')
      end
    end
  end
end
