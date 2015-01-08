require 'spec_helper'

describe Lappen::Filters::Orderer do
  subject { described_class.new(stack, *args) }
  let(:stack)  { double('stack', perform: nil) }
  let(:args)   { [] }
  let(:scope)  { double('scope') }
  let(:params) { {order: 'foo,-bar'} }

  describe '#perform' do
    before do
      allow(scope).to receive(:reorder) { scope }
    end

    context 'with an unallowed ordering' do
      it 'does not reorder the scope' do
        expect(scope).to_not receive(:reorder)
        subject.perform(scope, params)
      end

      it_behaves_like 'a filter that calls the stack'
    end

    context 'without an allowed ordering' do
      let(:args) { [:foo, :bar] }

      it 'reorders the scope' do
        expect(scope).to receive(:reorder).with({'foo' => :asc, 'bar' => :desc})
        subject.perform(scope, params)
      end

      it_behaves_like 'a filter that calls the stack'
    end
  end
end
