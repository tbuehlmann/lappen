require 'spec_helper'

describe Lappen::Filters::Pundit do
  describe '#perform' do
    subject { described_class.new(stack, *args) }
    let(:stack)  { double('stack', perform: nil) }
    let(:args)   { [] }
    let(:scope)  { double('scope') }
    let(:params) { {} }

    context 'with a corresponding Pundit scope' do
      let(:resolved_policy_scope) { double('resolved_policy_scope') }

      before do
        allow(subject).to receive(:resolved_policy_scope) { resolved_policy_scope }
      end

      it 'changes the scope' do
        expect(stack).to receive(:perform).with(resolved_policy_scope, params)
        subject.perform(scope, params)
      end

      it_behaves_like 'a filter that calls the stack'
    end

    context 'without a corresponding Pundit scope' do
      before do
        allow(subject).to receive(:resolved_policy_scope)
      end

      it 'does not change the scope' do
        expect(stack).to receive(:perform).with(scope, params)
        subject.perform(scope, params)
      end

      it_behaves_like 'a filter that calls the stack'
    end
  end
end
