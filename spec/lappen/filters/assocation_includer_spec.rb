require 'spec_helper'

describe Lappen::Filters::AssociationIncluder do
  subject { described_class.new(stack, *args) }
  let(:stack)  { double('stack', perform: nil) }
  let(:args)   { [:category, :reviews] }
  let(:scope)  { double('scope') }
  let(:params) { double('params') }

  describe '#perform' do
    before do
      allow(scope).to receive(:includes)
    end

    it 'calls #includes on the scope' do
      expect(scope).to receive(:includes).with(args)
      subject.perform(scope, params)
    end

    it_behaves_like 'a filter that calls the stack'
  end
end
