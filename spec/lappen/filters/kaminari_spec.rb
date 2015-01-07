require 'spec_helper'
require 'active_support/core_ext/hash/indifferent_access'

describe Lappen::Filters::Kaminari do
  subject { described_class.new(stack, *args) }
  let(:stack)  { double('stack', perform: nil) }
  let(:args)   { [] }
  let(:scope)  { double('scope') }

  before do
    allow(scope).to receive(:page) { scope }
    allow(scope).to receive(:per)  { scope }
  end

  describe '#perform' do
    context 'with custom keys provided' do
      let(:args)   { [page_key: 'seite', per_key: 'pro'] }
      let(:params) { {seite: '5', pro: '42'}.with_indifferent_access }

      it 'calls #page and #per on the scope with the corresponding params' do
        expect(scope).to receive(:page).with('5')
        expect(scope).to receive(:per).with('42')

        subject.perform(scope, params)
      end
    end

    context 'without custom keys provided' do
      let(:params) { {page: '5', per: '42'}.with_indifferent_access }

      it 'calls #page and #per on the scope with the corresponding params' do
        expect(scope).to receive(:page).with('5')
        expect(scope).to receive(:per).with('42')

        subject.perform(scope, params)
      end
    end

    it 'calls stack#perform' do
      expect(stack).to receive(:perform).with(scope, {})
      subject.perform(scope, {})
    end
  end
end
