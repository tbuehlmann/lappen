require 'spec_helper'

describe Lappen::Filters::Orderer do
  subject { described_class.new(stack, *args, **options) }
  let(:stack)   { double('stack', perform: nil) }
  let(:args)    { [] }
  let(:options) { {} }
  let(:scope)   { double('scope') }
  let(:params)  { {order: 'foo,-bar'} }

  describe '#perform' do
    before do
      allow(scope).to receive(:order)   { scope }
      allow(scope).to receive(:reorder) { scope }
    end

    context 'with an unallowed ordering' do
      it 'does not order the scope' do
        expect(scope).to_not receive(:order)
        subject.perform(scope, params)
      end

      it_behaves_like 'a filter that calls the stack'
    end

    context 'without an allowed ordering' do
      let(:args) { [:foo, :bar] }

      it 'orders the scope' do
        expect(scope).to receive(:order).with({'foo' => :asc, 'bar' => :desc})
        subject.perform(scope, params)
      end

      it_behaves_like 'a filter that calls the stack'
    end

    context 'with the reorder option' do
      let(:args)    { [:foo, :bar] }
      let(:options) { {reorder: true} }

      it 'reorders the scope instead of just ordering' do
        expect(scope).to receive(:reorder).with({'foo' => :asc, 'bar' => :desc})
        subject.perform(scope, params)
      end

      it_behaves_like 'a filter that calls the stack'
    end
  end
end
