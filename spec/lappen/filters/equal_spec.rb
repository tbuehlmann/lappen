require 'spec_helper'
require 'action_controller'

describe Lappen::Filters::Equal do
  subject { described_class.new(*args, **options.merge(meta: meta)) }

  let(:options) { {} }
  let(:meta)    { {} }
  let(:scope)   { double('scope') }

  describe '#perform' do
    context 'with filterable attributes' do
      let(:args)    { [:name, :status] }
      let(:filters) { {name: 'foo', status: 42} }
      let(:params)  { {filter: filters}.with_indifferent_access }

      it 'filters the scope' do
        expect(scope).to receive(:where).with(any_args)
        subject.perform(scope, params)
      end

      it 'adds meta information' do
        allow(scope).to receive(:where)
        subject.perform(scope, params)

        expect(meta[:equal]).to eq(name: 'foo', status: 42)
      end
    end

    context 'without a configured filterable attribute' do
      let(:args)   { [] }
      let(:params) { {filter: {name: 'foo'}}.with_indifferent_access }

      it 'does not filter the scope' do
        expect(scope).to_not receive(:where)
        subject.perform(scope, params)
      end
    end

    context 'without a filterable key-value-pair in params' do
      let(:args)   { [:name] }
      let(:params) { {filter: {}}.with_indifferent_access }

      it 'does not filter the scope' do
        expect(scope).to_not receive(:where)
        subject.perform(scope, params)
      end
    end

    context 'with a malformed filters object' do
      let(:args)   { [] }
      let(:params) { {filter: nil}.with_indifferent_access }

      it 'does not filter the scope' do
        expect(scope).to_not receive(:where)
        subject.perform(scope, params)
      end
    end

    context 'with a malformed value type in params' do
      let(:args)    { [:name, :status] }
      let(:filters) { {name: {}, status: 42} }
      let(:params)  { {filter: filters}.with_indifferent_access }

      it 'does not filter the scope with invalid types' do
        expect(scope).to_not receive(:where).with(status: 42)
        subject.perform(scope, params)
      end
    end

    context 'with a different filter_key' do
      let(:options) { {filter_key: :custom_filter_key} }
      let(:args)    { [:name, :status] }
      let(:filters) { {name: 'foo', status: 42} }
      let(:params)  { {custom_filter_key: filters}.with_indifferent_access }

      it 'filters the scope' do
        expect(scope).to receive(:where).with(any_args)
        subject.perform(scope, params)
      end
    end

    context 'without a filter_key' do
      let(:options) { {filter_key: nil} }
      let(:args)    { [:name, :status] }
      let(:params)  { {name: 'foo', status: 42}.with_indifferent_access }

      it 'filters the scope' do
        expect(scope).to receive(:where).with(any_args)
        subject.perform(scope, params)
      end
    end
  end
end
