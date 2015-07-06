require 'spec_helper'

describe Lappen::Filters::AssociationIncluder do
  subject { described_class.new(*args, meta: meta) }

  let(:args)  { [:category, :reviews] }
  let(:meta)  { {} }
  let(:scope) { double('scope') }

  describe '#perform' do
    it '#includes the arguments in the scope' do
      expect(scope).to receive(:includes).with(args)
      subject.perform(scope)
    end

    it 'adds meta information' do
      allow(scope).to receive(:includes).with(args)
      subject.perform(scope)

      expect(meta[:include]).to match_array([:category, :reviews])
    end
  end
end
