require 'spec_helper'

describe Lappen::Filters::Pundit do
  describe '#perform' do
    subject { described_class.new(meta: meta) }

    let(:meta)    { {} }
    let(:scope)   { double('scope') }

    before do
      allow(subject).to receive(:pundit_user)

      module Pundit
        class Scope
          def initialize(pundit_user, scope)
          end

          def resolve
            42
          end
        end

        class PolicyFinder
          def initialize(scope)
          end

          def scope!
            Scope
          end
        end
      end
    end

    after do
      Object.send(:remove_const, :Pundit)
    end

    context 'with a corresponding Pundit scope' do
      it 'changes the scope' do
        expect(subject.perform(scope)).to eq(42)
      end

      it 'adds meta information' do
        subject.perform(scope)
        expect(meta[:pundit]).to match_array(Pundit::Scope)
      end
    end
  end
end
