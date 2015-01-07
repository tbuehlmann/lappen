require 'spec_helper'

describe Lappen::Filter do
  describe '#perform' do
    subject { described_class.new(stack) }
    let(:stack)  { double('stack', perform: nil) }
    let(:scope)  { double('scope') }
    let(:params) { double('params') }

    it 'calls #perform on the stack' do
      expect(stack).to receive(:perform).with(scope, params)
      subject.perform(scope, params)
    end
  end
end
