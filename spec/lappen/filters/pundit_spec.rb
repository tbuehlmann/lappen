require 'spec_helper'

describe Lappen::Filters::Pundit do
  describe '#perform' do
    subject { described_class.new(*args) }
    let(:args)   { [] }
    let(:scope)  { double('scope') }
    let(:params) { {} }

    context 'with a corresponding Pundit scope' do
      let(:policy_scope) { double('resolved_policy_scope') }

      before do
        allow(subject).to receive(:policy_scope) { policy_scope }
      end

      it 'changes the scope' do
        filtered_scope = subject.perform(scope, params)
        expect(filtered_scope).to eq(policy_scope)
      end
    end

    context 'without a corresponding Pundit scope' do
      before do
        allow(subject).to receive(:policy_scope) { nil }
      end

      it 'does not change the scope' do
        filtered_scope = subject.perform(scope, params)
        expect(filtered_scope).to eq(scope)
      end
    end
  end
end
