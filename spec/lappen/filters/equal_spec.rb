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
      let(:filters) { {'name' => 'foo', 'status' => 42} }
      let(:params)  { {'filter' => filters} }

      it 'filters the scope' do
        expect(scope).to receive(:where).with(filters)
        subject.perform(scope, params)
      end

      it 'adds meta information' do
        allow(scope).to receive(:where)
        subject.perform(scope, params)

        expect(meta[:exactly]).to eq(name: 'foo', status: 42)
      end
    end

    # ActiveRecord will raise an ActiveModel::ForbiddenAttributesError if
    # the passed argument is an unpermitted instance of ActionController::Parameters.
    context 'with ActionController::Parameters as params' do
      let(:args)    { [:name, :status] }
      let(:filters) { {'name' => 'foo', 'status' => 42} }
      let(:params)  { ActionController::Parameters.new('filter' => filters) }

      it 'calls .where with a Hash, not with ActionController::Parameters' do
        expect(scope).to receive(:where).with(instance_of(Hash))
        subject.perform(scope, params)
      end
    end

    context 'without a configured filterable attribute' do
      let(:args)   { [] }
      let(:params) { {filter: {'name' => 'foo'}} }

      it 'does not filter the scope' do
        expect(scope).to_not receive(:where)
        subject.perform(scope, params)
      end
    end

    context 'without a filterable key-value-pair in params' do
      let(:args)   { [:name] }
      let(:params) { {filter: {}} }

      it 'does not filter the scope' do
        expect(scope).to_not receive(:where)
        subject.perform(scope, params)
      end
    end

    context 'with a malformed filters object' do
      let(:args)   { [] }
      let(:params) { {filter: nil} }

      it 'does not filter the scope' do
        expect(scope).to_not receive(:where)
        subject.perform(scope, params)
      end
    end

    context 'with a malformed value type in params' do
      let(:args)    { [:name, :status] }
      let(:filters) { {'name' => {}, 'status' => 42} }
      let(:params)  { {filter: filters} }

      it 'does not filter the scope with invalid types' do
        expect(scope).to_not receive(:where).with('status' => 42)
        subject.perform(scope, params)
      end
    end

    context 'with a different filter_key' do
      let(:options) { {filter_key: 'filters_with_s'} }
      let(:args)    { [:name, :status] }
      let(:filters) { {'name' => 'foo', 'status' => 42} }
      let(:params)  { {'filters_with_s' => filters} }

      it 'filters the scope' do
        expect(scope).to receive(:where).with(filters)
        subject.perform(scope, params)
      end
    end

    context 'without a filter_key' do
      let(:options) { {filter_key: nil} }
      let(:args)    { [:name, :status] }
      let(:params)  { {'name' => 'foo', 'status' => 42} }

      it 'filters the scope' do
        expect(scope).to receive(:where).with(params)
        subject.perform(scope, params)
      end
    end
  end
end
