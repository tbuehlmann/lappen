require 'spec_helper'

describe Lappen::Filters::Exactly do
  subject { described_class.new(*args, meta: meta) }

  let(:meta)  { {} }
  let(:scope) { double('scope') }

  describe '#perform' do
    context 'with filterable attributes' do
      let(:args)   { [:name, :status] }
      let(:params) { {'name' => 'foo', 'status' => 42} }

      it 'filters the scope' do
        expect(scope).to receive(:where).with(params)
        subject.perform(scope, params)
      end

      it 'adds meta information' do
        allow(scope).to receive(:where)
        subject.perform(scope, params)

        expect(meta[:exactly]).to eq(name: 'foo', status: 42)
      end
    end

    context 'without a configured filterable attribute' do
      let(:args)   { [] }
      let(:params) { {name: 'foo'} }

      it 'does not filter the scope' do
        expect(scope).to_not receive(:where)
        subject.perform(scope, params)
      end
    end

    context 'without a filterable key-value-pair in params' do
      let(:args)   { [:name] }
      let(:params) { {} }

      it 'does not filter the scope' do
        expect(scope).to_not receive(:where)
        subject.perform(scope, params)
      end
    end

    context 'with a malformed value type in params' do
      let(:args)   { [:name] }
      let(:params) { {name: []} }

      it 'does not filter the scope since only Strings are allowed' do
        expect(scope).to_not receive(:where)
        subject.perform(scope, params)
      end
    end
  end
end
