require 'spec_helper'

describe Lappen::Filters::Draper do
  subject { described_class.new(stack, *args) }
  let(:stack)  { double('stack', perform: nil) }
  let(:args)   { [] }
  let(:scope)  { double('scope') }
  let(:params) { double('params')}

  describe '#perform' do
    before do
      allow(scope).to receive(:decorate)
    end

    it 'calls #decorate on the scope' do
      expect(scope).to receive(:decorate)
      subject.perform(scope, params)
    end

    it_behaves_like 'a filter that calls the stack'
  end
end
