require 'spec_helper'
require 'active_support/core_ext/hash/indifferent_access'

describe Lappen::Filters::Filterer do
  subject { described_class.new(stack, *args) }
  let(:stack) { double('stack', perform: nil) }
  let(:scope) { double('scope') }

  describe '#perform' do
    context 'with filterable attributes' do
      let(:args)   { [:name, :status] }
      let(:params) { {name: 'foo', status: '42'}.with_indifferent_access }

      before do
        expect(scope).to receive(:with_name).with('foo') { scope }
        expect(scope).to receive(:with_status).with('42')  { scope }
      end

      it 'filters the scope' do
        subject.perform(scope, params)
      end

      it_behaves_like 'a filter that calls the stack'
    end

    context 'without a configured filterable attribute' do
      let(:args)   { [] }
      let(:params) { {name: 'foo'} }

      it 'does not filter the scope' do
        expect(scope).to_not receive(:with_name)
        subject.perform(scope, params)
      end

      it_behaves_like 'a filter that calls the stack'
    end

    context 'without a filterable key-value-pair in params' do
      let(:args)   { [:name] }
      let(:params) { {} }

      it 'does not filter the scope' do
        expect(scope).to_not receive(:with_name)
        subject.perform(scope, params)
      end

      it_behaves_like 'a filter that calls the stack'
    end
  end
end
