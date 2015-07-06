require 'spec_helper'

describe Lappen::Filters::AssociationEmbedder do
  subject { described_class.new(*args, meta: meta) }

  let(:meta)  { {} }
  let(:scope) { double('scope') }

  describe '#perform' do
    before do
      allow(scope).to receive(:includes)
    end

    context 'with a configured association' do
      let(:args) { [:reviews] }

      context 'with a matching association from params' do
        let(:params)   { {include: 'reviews'} }
        let(:includer) { double('association_includer', perform: nil) }

        it 'includes the association' do
          expect(Lappen::Filters::AssociationIncluder).to receive(:new).with('reviews', meta: meta) { includer }
          expect(includer).to receive(:perform).with(scope)

          subject.perform(scope, params)
        end
      end

      context 'without a matching association' do
        let(:params) { {include: 'category'} }

        it 'does not include anything' do
          expect(Lappen::Filters::AssociationIncluder).to_not receive(:new)
          subject.perform(scope, params)
        end
      end
    end

    context 'without a configured association' do
      let(:args) { [] }
      let(:params) { {include: 'reviews'} }

      it 'does not include anything' do
        expect(Lappen::Filters::AssociationIncluder).to_not receive(:new)
        subject.perform(scope, params)
      end
    end
  end
end
