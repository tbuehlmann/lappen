require 'spec_helper'

describe Lappen::Filters::Kaminari do
  subject { described_class.new(**options.merge(meta: meta)) }

  let(:options)  { {} }
  let(:meta)     { {} }
  let(:scope)    { double('scope') }

  describe '#perform' do
    before do
      allow(scope).to receive(:page) { scope }
      allow(scope).to receive(:per)  { scope }
    end

    context 'with custom keys provided' do
      let(:options) { {page_key: 'seite', per_key: 'pro', meta: meta} }
      let(:params)  { {'seite' => 5, 'pro' => 42} }

      it 'calls #page and #per on the scope with the corresponding params' do
        expect(scope).to receive(:page).with(5)
        expect(scope).to receive(:per).with(42)

        subject.perform(scope, params)
      end

      it 'adds meta information' do
        subject.perform(scope, params)
        expect(meta[:pagination]).to eq(page: 5, per: 42)
      end
    end

    context 'without custom keys provided' do
      let(:params) { {'page' => 5, 'per' => 42} }

      it 'calls #page and #per on the scope with the corresponding params' do
        expect(scope).to receive(:page).with(5)
        expect(scope).to receive(:per).with(42)

        subject.perform(scope, params)
      end

      it 'adds meta information' do
        subject.perform(scope, params)
        expect(meta[:pagination]).to eq(page: 5, per: 42)
      end
    end
  end
end
